module PostgresExt::ActiveRecord
  module PredicateBuilder # :nodoc:
    def self.prepended(klass)
      klass.class_eval do
        class << klass
          prepend ClassMethods
        end
      end
    end

    module ClassMethods
      private

    def self.build(attribute, value)
      case value
      when Array
        engine = attribute.relation.engine
        column = engine.connection.columns(attribute.relation.name).detect{ |col| col.name.to_s == attribute.name.to_s }
        if column && column.array
            attribute.eq(value)
          else
            super
          end
        else
          super
        end
      end
    end
  end
end
