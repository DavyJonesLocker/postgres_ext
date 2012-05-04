require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLColumn
      def klass
        case type
        when :inet, :cidr   then NetAddr::CIDR
        end
        super
      end
      def type_cast(value)
        #debugger
        return nil if value.nil?
        return coder.load(value) if encoded?

        klass = self.class

        case type
        when :inet, :cidr   then klass.string_to_cidr_address(value)
        else super
        end
      end
      def type_cast_code(var_name)
        #debugger
        klass = self.class.name

        case type
        when :inet then "#{klass}.string_to_cidr_address(#{var_name})"
        else super
        end
      end

      class << self
        def string_to_cidr_address(string)
          return string unless String === string
          return NetAddr::CIDR.create(string)
        end
      end
      private

      def simplified_type_with_extended_types(field_type)
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
          simplified_type_without_extended_types field_type
        end
      end

      alias_method_chain :simplified_type, :extended_types
    end

    class PostgreSQLAdapter
      EXTENDED_TYPES = {:inet => {:name => 'inet'}, :cidr => {:name => 'cidr'}, :macaddr => {:name => 'macaddr'},
                        :inet_array => {:name => 'inet', :array => true}, :cidr_array => {:name => 'cidr', :array => true},
                        :macaddr_array => {:name => 'macaddr', :array => true}, :integer_array => {:name => 'integer', :array => true},
                        :string_array => {:name => 'string', :limit => 255, :array => true}}

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

      def type_to_sql_with_extended_types(type, limit = nil, precision = nil, scale = nil)
        if native = native_database_types[type.to_sym]
          if (type != :primary_key) && native[:array]
            column_type_sql = (type_to_sql_without_extended_types(native[:name], limit, precision, scale) rescue native[:name]).dup
            column_type_sql << '[]'
          else
            column_type_sql = type_to_sql_without_extended_types(type, limit, precision, scale).dup
          end
        end
        column_type_sql
      end
      alias_method_chain :type_to_sql, :extended_types

      def type_cast_with_extended_types(value, column)

        case value
        when NetAddr::CIDR
          return value.to_s
        else type_cast_without_extended_types(value,column)
        end
      end
      alias_method_chain :type_cast, :extended_types
    end
  end
end
