require 'active_record/relation/predicate_builder'

module ActiveRecord
  class PredicateBuilder # :nodoc:
    def self.build_from_hash(engine, attributes, default_table, allow_table_name = true)
      predicates = attributes.map do |column, value|
        table = default_table

        if allow_table_name && value.is_a?(Hash)
          table = Arel::Table.new(column, engine)

          if value.empty?
            '1 = 2'
          else
            build_from_hash(engine, value, table, false)
          end
        else
          column = column.to_s

          if allow_table_name && column.include?('.')
            table_name, column = column.split('.', 2)
            table = Arel::Table.new(table_name, engine)
          end

          attribute = table[column.to_sym]

          case value
          when ActiveRecord::Relation
            value = value.select(value.klass.arel_table[value.klass.primary_key]) if value.select_values.empty?
            attribute.in(value.arel.ast)
          when Array, ActiveRecord::Associations::CollectionProxy
            column_definition = engine.columns.find { |col| col.name == column }

            if column_definition.respond_to?(:array) && column_definition.array
              attribute.eq(value)
            else
              values = value.to_a.map {|x| x.is_a?(ActiveRecord::Base) ? x.id : x}
              ranges, values = values.partition {|v| v.is_a?(Range) || v.is_a?(Arel::Relation)}

              array_predicates = ranges.map {|range| attribute.in(range)}

              if values.include?(nil)
                values = values.compact
                if values.empty?
                  array_predicates << attribute.eq(nil)
                else
                  array_predicates << attribute.in(values.compact).or(attribute.eq(nil))
                end
              else
                array_predicates << attribute.in(values)
              end

              array_predicates.inject {|composite, predicate| composite.or(predicate)}
            end
          when Range, Arel::Relation
            attribute.in(value)
          when ActiveRecord::Base
            attribute.eq(value.id)
          when Class
            # FIXME: I think we need to deprecate this behavior
            attribute.eq(value.name)
          else
            attribute.eq(value)
          end
        end
      end

      predicates.flatten
    end
  end
end
