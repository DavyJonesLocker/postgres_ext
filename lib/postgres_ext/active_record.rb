require 'postgres_ext/active_record/relation'
require 'postgres_ext/active_record/cte_proxy'
require 'postgres_ext/active_record/querying'

module PostgresExt
  module ExceptionalValidations
    def save(*)
      begin
        super
      rescue => e
        pg_error = e.original_exception
        error_attribute = pg_error.result.error_field(PG::Result::PG_DIAG_COLUMN_NAME)
        self.errors.add_on_blank(error_attribute)
        false
      end
    end
  end
end

ActiveRecord::Base.send(:include, PostgresExt::ExceptionalValidations)
