require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLColumn
      private

      def simplified_type(field_type)
        #debugger
        case field_type
        when 'inet'
          :inet
        when 'cidr'
          :cidr
        when 'macaddr'
          :macaddr
        when /(\[\])$/
          "#{simplified_type field_type[0..field_type.length - 3]}_array".to_sym
        else
          super
        end
      end
    end

    class PostgreSQLAdapter
      EXTENDED_TYPES = {:inet => {:name => 'inet'}, :cidr => {:name => 'cidr'}, :macaddr => {:name => 'macaddr'},
                        :inet_array => {:name => 'inet', :array => true}, :cidr_array => {:name => 'cidr', :array => true},
                        :macaddr_array => {:name => 'macaddr', :array => true}, :integer_array => {:name => 'integer', :array => true},
                        :string_array => {:name => 'character varying', :limit => 255, :array => true}}

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
      end

      class Table
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

      def type_to_sql(type, limit = nil, precision = nil, scale = nil)
        column_type_sql = super

        if native = native_database_types[type.to_sym]
          if (type != :primary_key) && native[:array]
            column_type_sql << '[]'
          end
        end

        column_type_sql
      end
    end
  end
end
