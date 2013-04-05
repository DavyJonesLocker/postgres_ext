require 'active_record/connection_adapters/postgresql_adapter'
require 'ipaddr'
require 'pg_array_parser'

module ActiveRecord
  module ConnectionAdapters
    class IndexDefinition
      attr_accessor :using, :where, :index_opclass
    end

    class PostgreSQLColumn
      include PgArrayParser
      attr_accessor :array

      def initialize_with_extended_types(name, default, sql_type = nil, null = true)
        if sql_type =~ /\[\]$/
          @array = true
          initialize_without_extended_types(name, default, sql_type[0..sql_type.length - 3], null)
          @sql_type = sql_type
        else
          initialize_without_extended_types(name,default, sql_type, null)
        end
      end
      alias_method_chain :initialize, :extended_types

      def klass_with_extended_types
        case type
        when :inet, :cidr   then IPAddr
        else
          klass_without_extended_types
        end
      end
      alias_method_chain :klass, :extended_types

      def type_cast_with_extended_types(value)
        return nil if value.nil?
        return coder.load(value) if encoded?

        klass = self.class
        if self.array && String === value && value.start_with?('{') && value.end_with?('}')
          string_to_array value
        elsif self.array && Array === value
          value
        else
          case type
          when :inet, :cidr   then klass.string_to_cidr_address(value)
          when :numeric_range then klass.string_to_numeric_range(value)
          else
            type_cast_without_extended_types(value)
          end
        end
      end
      alias_method_chain :type_cast, :extended_types


      def string_to_array(value)
        if Array === value
          value
        else
          string_array = parse_pg_array value
          if type == :string || type == :text
            force_character_encoding(string_array)
          else
            type_cast_array(string_array)
          end
        end
      end

      def type_cast_array(array)
        array.map do |value|
          Array === value ? type_cast_array(value) : type_cast(value)
        end
      end

      def number?
        !self.array && super
      end

      def type_cast_code_with_extended_types(var_name)
        klass = self.class.name

        if self.array
          "#{klass}.new('#{self.name}', #{self.default.nil? ? 'nil' : "'#{self.default}'"}, '#{self.sql_type}').string_to_array(#{var_name})"
        else
          case type
          when :inet, :cidr   then "#{klass}.string_to_cidr_address(#{var_name})"
          when :numeric_range then "#{klass}.string_to_numeric_range(#{var_name})"
          else
            type_cast_code_without_extended_types(var_name)
          end
        end
      end
      alias_method_chain :type_cast_code, :extended_types

      class << self
        def extract_value_from_default_with_extended_types(default)
          case default
          when /\A'(.*)'::(?:numrange)\z/
            $1
          else
            extract_value_from_default_without_extended_types(default)
          end

        end
        alias_method_chain :extract_value_from_default, :extended_types
        def string_to_cidr_address(string)
          return string unless String === string

          if string.present?
            IPAddr.new(string)
          end
        end

        def string_to_numeric_range(value)
          if Range === value
            value
          else
            # Until 1.8.7 support is dropped, must use group numbers instead of named groups
            #range_regex = /\A(?<open>\[|\()(?<start>.*?),(?<end>.*?)(?<close>\]|\))\z/
            range_regex = /\A(\[|\()(.*?),(.*?)(\]|\))\z/
            if match = value.match(range_regex)
              start_value = match[2].empty? ? -(1.0/0.0) : match[2].to_i
              end_value   = match[3].empty? ? (1.0/0.0) : match[3].to_i
              end_exclusive = end_value != (1.0/0.0) && match[4] == ')'
              Range.new start_value, end_value, end_exclusive
            end
          end
        end
      end

      private

      def force_character_encoding(string_array)
        string_array.map do |item|
          item.respond_to?(:force_encoding) ? item.force_encoding(ActiveRecord::Base.connection.encoding_for_ruby) : item
        end
      end

      def simplified_type_with_extended_types(field_type)
        case field_type
        when 'uuid'
          :uuid
        when 'citext'
          :citext
        when 'inet'
          :inet
        when 'cidr'
          :cidr
        when 'macaddr'
          :macaddr
        when 'ean13'
          :ean13
        when 'int4range'
          :integer_range
        when 'int8range'
          :integer_range
        when 'numrange'
          :numeric_range
        else
          simplified_type_without_extended_types field_type
        end
      end

      alias_method_chain :simplified_type, :extended_types
    end

    class PostgreSQLAdapter
      class UnsupportedFeature < Exception; end

      EXTENDED_TYPES = { :inet => {:name => 'inet'}, :cidr => {:name => 'cidr'}, :macaddr => {:name => 'macaddr'},
                         :uuid => {:name => 'uuid'}, :citext => {:name => 'citext'}, :ean13 => {:name => 'ean13'}, :numeric_range => { :name => 'numrange' } }

      class ColumnDefinition < ActiveRecord::ConnectionAdapters::ColumnDefinition
        attr_accessor :array
      end

      class TableDefinition
        EXTENDED_TYPES.keys.map(&:to_s).each do |column_type|
          class_eval <<-EOV, __FILE__, __LINE__ + 1
            def #{column_type}(*args)                                   # def string(*args)
              options = args.extract_options!                           #   options = args.extract_options!
              column_names = args                                       #   column_names = args
              type = :'#{column_type}'                                  #   type = :string
              column_names.each { |name| column(name, type, options) }  #   column_names.each { |name| column(name, type, options) }
            end                                                         # end
          EOV
        end

        def column(name, type=nil, options = {})
          super

          column = self[name]
          column.array     = options[:array]

          self
        end

        private

        def new_column_definition(base, name, type)
          definition = ColumnDefinition.new base, name, type
          @columns << definition
          @columns_hash[name] = definition
          definition
        end
      end

      class Table < ActiveRecord::ConnectionAdapters::Table
        EXTENDED_TYPES.keys.map(&:to_s).each do |column_type|
          class_eval <<-EOV, __FILE__, __LINE__ + 1
            def #{column_type}(*args)                                          # def string(*args)
              options = args.extract_options!                                  #   options = args.extract_options!
              column_names = args                                              #   column_names = args
              type = :'#{column_type}'                                         #   type = :string
              column_names.each do |name|                                      #   column_names.each do |name|
                column = ColumnDefinition.new(@base, name.to_s, type)          #     column = ColumnDefinition.new(@base, name, type)
                if options[:limit]                                             #     if options[:limit]
                  column.limit = options[:limit]                               #       column.limit = options[:limit]
                elsif native[type].is_a?(Hash)                                 #     elsif native[type].is_a?(Hash)
                  column.limit = native[type][:limit]                          #       column.limit = native[type][:limit]
                end                                                            #     end
                column.precision = options[:precision]                         #     column.precision = options[:precision]
                column.scale = options[:scale]                                 #     column.scale = options[:scale]
                column.default = options[:default]                             #     column.default = options[:default]
                column.null = options[:null]                                   #     column.null = options[:null]
                @base.add_column(@table_name, name, column.sql_type, options)  #     @base.add_column(@table_name, name, column.sql_type, options)
              end                                                              #   end
            end                                                                # end
          EOV
        end
      end

      NATIVE_DATABASE_TYPES.merge!(EXTENDED_TYPES)

      # Translate from the current database encoding to the encoding we
      # will force string array components into on retrievial.
      def encoding_for_ruby
        @database_encoding ||= case ActiveRecord::Base.connection.encoding
                               when 'UTF8'
                                 'UTF-8'
                               when 'SQL_ASCII'
                                 'ASCII'
                               else
                                 ActiveRecord::Base.connection.encoding
                               end
      end

      def supports_extensions?
        postgresql_version > 90100
      end

      def add_column_options!(sql, options)
        if options[:array] || options[:column].try(:array)
          sql << '[]'
        end
        super
      end

      def add_index(table_name, column_name, options = {})
        index_name, unique, index_columns, _ = add_index_options(table_name, column_name, options)
        if options.is_a? Hash
          index_type = options[:using] ? " USING #{options[:using]} " : ""
          index_options = options[:where] ? " WHERE #{options[:where]}" : ""
          index_opclass = options[:index_opclass]
          index_algorithm = options[:algorithm] == :concurrently ? ' CONCURRENTLY' : ''

          if options[:algorithm].present? && options[:algorithm] != :concurrently
            raise ArgumentError.new 'Algorithm must be one of the following: :concurrently'
          end
        end
        execute "CREATE #{unique} INDEX#{index_algorithm} #{quote_column_name(index_name)} ON #{quote_table_name(table_name)}#{index_type}(#{index_columns} #{index_opclass})#{index_options}"
      end

      def add_extension(extension_name, options={})
        raise UnsupportedFeature.new('Extensions are not support by this version of PostgreSQL') unless supports_extensions?
        execute "CREATE extension IF NOT EXISTS \"#{extension_name}\""
      end

      def change_table(table_name, options = {})
        if supports_bulk_alter? && options[:bulk]
          recorder = ActiveRecord::Migration::CommandRecorder.new(self)
          yield Table.new(table_name, recorder)
          bulk_change_table(table_name, recorder.commands)
        else
          yield Table.new(table_name, self)
        end
      end

      if RUBY_PLATFORM =~ /java/
        # The activerecord-jbdc-adapter implements PostgreSQLAdapter#add_column differently from the active-record version
        # so we have to patch that version in JRuby, but not in MRI/YARV
        def add_column(table_name, column_name, type, options = {})
          default = options[:default]
          notnull = options[:null] == false
          sql_type = type_to_sql(type, options[:limit], options[:precision], options[:scale])

          if options[:array]
            sql_type << '[]'
          end

          # Add the column.
          execute("ALTER TABLE #{quote_table_name(table_name)} ADD COLUMN #{quote_column_name(column_name)} #{sql_type}")

          change_column_default(table_name, column_name, default) if options_include_default?(options)
          change_column_null(table_name, column_name, false, default) if notnull
        end
      end

      def type_cast_extended(value, column, part_array = false)
        case value
        when NilClass
          if column.array && part_array
            'NULL'
          elsif column.array && !part_array
            value
          else
            type_cast_without_extended_types(value, column)
          end
        when Float
          if column.type == :numeric_range && value.abs == (1.0/0.0)
            ''
          else
            type_cast_without_extended_types(value, column)
          end
        when Range
          range_to_string(value, column)
        when Array
          if column.array
            array_to_string(value, column)
          else
            type_cast_without_extended_types(value, column)
          end
        when IPAddr
          ipaddr_to_string(value)
        else
          type_cast_without_extended_types(value, column)
        end
      end

      def type_cast_with_extended_types(value, column)
        type_cast_extended(value, column)
      end
      alias_method_chain :type_cast, :extended_types

      def quote_with_extended_types(value, column = nil)
        if value.is_a? IPAddr
          "'#{type_cast(value, column)}'"
        elsif value.is_a? Array
          "'#{array_to_string(value, column, true)}'"
        elsif column.respond_to?(:array) && column.array && value =~ /^\{.*\}$/
          "'#{value}'"
        elsif value.is_a? Range
          "'#{type_cast(value, column)}'"
        else
          quote_without_extended_types(value, column)
        end
      end
      alias_method_chain :quote, :extended_types

      def opclasses
        @opclasses ||= select_rows('SELECT opcname FROM pg_opclass').flatten.uniq
      end

      # this is based upon rails 4 changes to include different index methods
      # Returns an array of indexes for the given table.
      def indexes(table_name, name = nil)
        opclasses
         result = select_rows(<<-SQL, name)
           SELECT distinct i.relname, d.indisunique, d.indkey, pg_get_indexdef(d.indexrelid), t.oid
           FROM pg_class t
           INNER JOIN pg_index d ON t.oid = d.indrelid
           INNER JOIN pg_class i ON d.indexrelid = i.oid
           WHERE i.relkind = 'i'
             AND d.indisprimary = 'f'
             AND t.relname = '#{table_name}'
             AND i.relnamespace IN (SELECT oid FROM pg_namespace WHERE nspname = ANY (current_schemas(false)) )
          ORDER BY i.relname
        SQL
        result.map do |row|
          index_name = row[0]
          unique = row[1] == 't'
          indkey = row[2].split(" ")
          inddef = row[3]
          oid = row[4]

          columns = Hash[select_rows(<<-SQL, "Columns for index #{row[0]} on #{table_name}")]
          SELECT a.attnum::text, a.attname
          FROM pg_attribute a
          WHERE a.attrelid = #{oid}
          AND a.attnum IN (#{indkey.join(",")})
          SQL
          column_names = columns.values_at(*indkey).compact

          # add info on sort order for columns (only desc order is explicitly specified, asc is the default)
          desc_order_columns = inddef.scan(/(\w+) DESC/).flatten
          orders = desc_order_columns.any? ? Hash[desc_order_columns.map {|order_column| [order_column, :desc]}] : {}
          #changed from rails 3.2
          where = inddef.scan(/WHERE (.+)$/).flatten[0]
          using = inddef.scan(/USING (.+?) /).flatten[0].to_sym
          if using
            index_op = inddef.scan(/USING .+? \(.+? (#{opclasses.join('|')})\)/).flatten
            index_op = index_op[0].to_sym if index_op.present?
          end
          if column_names.present?
            index_def = IndexDefinition.new(table_name, index_name, unique, column_names, [], orders)
            index_def.where = where
            index_def.using = using if using && using != :btree
            index_def.index_opclass = index_op if using && using != :btree && index_op
            index_def
          # else nil
          end
          #/changed
        end.compact
      end

      def extensions
        select_rows('select extname from pg_extension', 'extensions').map { |row| row[0] }.delete_if {|name| name == 'plpgsql'}
      end

      private

      def ipaddr_to_string(value)
        "#{value.to_s}/#{value.instance_variable_get(:@mask_addr).to_s(2).count('1')}"
      end

      def array_to_string(value, column, encode_single_quotes = false)
        "{#{value.map { |val| item_to_string(val, column, encode_single_quotes) }.join(',')}}"
      end

      def range_to_string(value, column)
        "#{range_lower_bound_character value}#{type_cast value.begin, column},#{type_cast value.end, column}#{range_upper_bound_character value}"
      end

      def range_lower_bound_character(value)
        if value.begin == -(1.0/0.0)
          '('
        else
          '['
        end
      end

      def range_upper_bound_character(value)
        if value.end == (1.0/0.0) || value.exclude_end?
          ')'
        else
          ']'
        end
      end

      def item_to_string(value, column, encode_single_quotes = false)
        return 'NULL' if value.nil?

        casted_value = type_cast_extended(value, column, true)

        if casted_value.is_a?(String) && value.is_a?(String)
          casted_value = casted_value.dup
          # Encode backslashes.  One backslash becomes 4 in the resulting SQL.
          # (why 4, and not 2?  Trial and error shows 4 works, 2 fails to parse.)
          casted_value.gsub!('\\', '\\\\\\\\')
          # Encode a bare " in the string as \"
          casted_value.gsub!('"', '\\"')
          # PostgreSQL parses the string values differently if they are quoted for
          # use in a statement, or if it will be used as part of a bound argument.
          # For directly-inserted values (UPDATE foo SET bar='{"array"}') we need to
          # escape ' as ''.  For bound arguments, do not escape them.
          if encode_single_quotes
            casted_value.gsub!("'", "''")
          end

          "\"#{casted_value}\""
        else
          casted_value
        end
      end
    end
  end
end
