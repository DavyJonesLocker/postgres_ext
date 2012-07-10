require 'active_record/connection_adapters/postgresql_adapter'
require 'ipaddr'
require 'pg_array_parser'

module ActiveRecord
  module ConnectionAdapters
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
        if self.array && value.start_with?('{') && value.end_with?('}')
          string_to_array value
        else
          case type
          when :inet, :cidr   then klass.string_to_cidr_address(value)
          else 
            type_cast_without_extended_types(value)
          end
        end
      end
      alias_method_chain :type_cast, :extended_types
      def string_to_array(value)
        string_array = parse_pg_array value
        if type == :string
          string_array
        else
          type_cast_array(string_array)
        end
      end

      def type_cast_array(array)
        casted_array = []
        array.each do |value|
          if Array === value
            casted_array.push type_cast_array(value)
          else
            casted_array.push type_cast value
          end
        end
        casted_array
      end

      def type_cast_code_with_extended_types(var_name)
        klass = self.class.name

        case type
        when :inet, :cidr   then "#{klass}.string_to_cidr_address(#{var_name})"
        else
          type_cast_code_without_extended_types(var_name)
        end
      end
      alias_method_chain :type_cast_code, :extended_types

      class << self
        def string_to_cidr_address(string)
          return string unless String === string
          return IPAddr.new(string)
        end
      end
      private

      def simplified_type_with_extended_types(field_type)
        case field_type
        when 'uuid'
          :uuid
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
      EXTENDED_TYPES = {:inet => {:name => 'inet'}, :cidr => {:name => 'cidr'}, :macaddr => {:name => 'macaddr'}, :uuid => {:name => 'uuid'}}
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

      def add_column_options!(sql, options)
        if options[:array] || options[:column].try(:array)
          sql << '[]'
        end
        super
      end

      def type_cast_with_extended_types(value, column, part_array = false)
        case value
        when NilClass
          if column.array && part_array
            'NULL'
          elsif column.array && !part_array
            value
          else
            type_cast_without_extended_types(value, column)
          end
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
      alias_method_chain :type_cast, :extended_types

      private

      def ipaddr_to_string(value)
        "#{value.to_s}/#{value.instance_variable_get(:@mask_addr).to_s(2).count('1')}"
      end

      def array_to_string(value, column)
        "{#{value.map{|val| type_cast(val, column, true)}.join(',')}}"
      end
    end
  end
end
