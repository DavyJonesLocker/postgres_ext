require 'active_record/schema_dumper'

module ActiveRecord
  class SchemaDumper
    VALID_COLUMN_SPEC_KEYS = [:name, :limit, :precision, :scale, :default, :null, :array]
    def self.valid_column_spec_keys
      VALID_COLUMN_SPEC_KEYS
    end

    def dump(stream)
      header(stream)
      # added
      extensions(stream) if @connection.supports_extensions?
      # /added
      tables(stream)
      trailer(stream)
      stream
    end

    private

    def extensions(stream)
      exts = @connection.extensions

      unless exts.empty?
        stream.puts exts.map { |name| "  add_extension \"#{name}\""}.join("\n") + "\n\n"
      end
    end

    def table(table, stream)
      columns = @connection.columns(table)
      begin
        tbl = StringIO.new

        # first dump primary key column
        if @connection.respond_to?(:pk_and_sequence_for)
          pk, _ = @connection.pk_and_sequence_for(table)
        elsif @connection.respond_to?(:primary_key)
          pk = @connection.primary_key(table)
        end

        tbl.print "  create_table #{table.inspect}"
        if columns.detect { |c| c.name == pk }
          if pk != 'id'
            tbl.print %Q(, :primary_key => "#{pk}")
          end
        else
          tbl.print ", :id => false"
        end
        tbl.print ", :force => true"
        tbl.puts " do |t|"

        # then dump all non-primary key columns
        column_specs = columns.map do |column|
          raise StandardError, "Unknown type '#{column.sql_type}' for column '#{column.name}'" if @types[column.type].nil?
          next if column.name == pk
          spec = column_spec(column)
          (spec.keys - [:name, :type]).each{ |k| spec[k].insert(0, "#{k.inspect} => ")}
          spec
        end.compact

        # find all migration keys used in this table
        keys = self.class.valid_column_spec_keys & column_specs.map{ |k| k.keys }.flatten

        # figure out the lengths for each column based on above keys
        lengths = keys.map{ |key| column_specs.map{ |spec| spec[key] ? spec[key].length + 2 : 0 }.max }

        # the string we're going to sprintf our values against, with standardized column widths
        format_string = lengths.map{ |len| "%-#{len}s" }

        # find the max length for the 'type' column, which is special
        type_length = column_specs.map{ |column| column[:type].length }.max

        # add column type definition to our format string
        format_string.unshift "    t.%-#{type_length}s "

        format_string *= ''

        column_specs.each do |colspec|
          values = keys.zip(lengths).map{ |key, len| colspec.key?(key) ? colspec[key] + ", " : " " * len }
          values.unshift colspec[:type]
          tbl.print((format_string % values).gsub(/,\s*$/, ''))
          tbl.puts
        end

        tbl.puts "  end"
        tbl.puts

        indexes(table, tbl)

        tbl.rewind
        stream.print tbl.read
      rescue => e
        stream.puts "# Could not dump table #{table.inspect} because of following #{e.class}"
        stream.puts "#   #{e.message}"
        stream.puts
      end

      stream
    end

    #mostly rails 3.2 code
    def indexes(table, stream)
      if (indexes = @connection.indexes(table)).any?
        add_index_statements = indexes.map do |index|
          statement_parts = [
            ('add_index ' + index.table.inspect),
            index.columns.inspect,
            (':name => ' + index.name.inspect),
          ]
          statement_parts << ':unique => true' if index.unique

          index_lengths = (index.lengths || []).compact
          statement_parts << (':length => ' + Hash[index.columns.zip(index.lengths)].inspect) unless index_lengths.empty?

          index_orders = (index.orders || {})
          statement_parts << (':order => ' + index.orders.inspect) unless index_orders.empty?

          # changed from rails 2.3
          statement_parts << (':where => ' + index.where.inspect) if index.where
          statement_parts << (':index_type => ' + index.index_type.inspect) if index.index_type
          statement_parts << (':index_opclass => ' + index.index_opclass.inspect) if index.index_opclass.present?
          # /changed

          '  ' + statement_parts.join(', ')
        end

        stream.puts add_index_statements.sort.join("\n")
        stream.puts
      end
    end

    #mostly rails 3.2 code (pulled out of table method)
    def column_spec(column)
      spec = {}
      spec[:name]      = column.name.inspect

      # AR has an optimization which handles zero-scale decimals as integers. This
      # code ensures that the dumper still dumps the column as a decimal.
      spec[:type]      = if column.type == :integer && [/^numeric/, /^decimal/].any? { |e| e.match(column.sql_type) }
                           'decimal'
                         else
                           column.type.to_s
                         end
      spec[:limit]     = column.limit.inspect if column.limit != @types[column.type][:limit] && spec[:type] != 'decimal'
      spec[:precision] = column.precision.inspect if column.precision
      spec[:scale]     = column.scale.inspect if column.scale
      spec[:null]      = 'false' unless column.null
      spec[:default]   = default_string(column.default) if column.has_default?
      # changed from rails 3.2 code
      spec[:array]     = 'true' if column.respond_to?(:array) && column.array
      # /changed
      spec
    end
  end
end
