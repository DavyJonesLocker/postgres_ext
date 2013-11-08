require 'postgres_ext/active_record/relation'
require 'postgres_ext/active_record/cte_proxy'
require 'postgres_ext/active_record/querying'

module PostgresExt
  module ExceptionalValidations
    def save(*)
      begin
        super
      rescue ActiveRecord::RecordNotUnique => e
        pg_error = e.original_exception
        if pg_error.result
          if index_name = pg_error.result.error_field(PG::Result::PG_DIAG_CONSTRAINT_NAME)
            klass = self.class
            index = klass.connection.indexes(klass.table_name).find {|ind| ind.name == index_name}
            error_attribute = index.columns
          end
          if Array === error_attribute
            error_attribute.each do |attr|
              self.errors.add(attr, :taken)
            end
          end
          false
        else
          raise e
        end
      rescue ActiveRecord::StatementInvalid => e
        pg_error = e.original_exception
        if pg_error.result
          error_attribute = get_error_attribute(pg_error)
          self.errors.add_on_blank(error_attribute)
          false
        else
          raise e
        end
      end
    end

    def get_error_attribute(pg_error)
      pg_error.result.error_field PG::Result::PG_DIAG_COLUMN_NAME
    end
  end
end

if defined?(PG::Result::PG_DIAG_COLUMN_NAME)
  ActiveRecord::Base.send(:include, PostgresExt::ExceptionalValidations)
end
