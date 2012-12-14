require 'active_record/sanitization'

module ActiveRecord
  module Sanitization
    extend ActiveSupport::Concern

    module ClassMethods
      def sanitize_sql_hash_for_assignment(attrs)
        attrs.map do |attr, value|
          "#{connection.quote_column_name(attr)} = #{quote_bound_value(value, attr)}"
        end.join(', ')
      end

      def quote_bound_value(value, column = nil, c = connection)
        if column.present? && column != c
          record_column = self.columns.select {|col| col.name == column}.first
          c.quote(value, record_column)
        elsif value.respond_to?(:map) && !value.acts_like?(:string)
          if value.respond_to?(:empty?) && value.empty?
            c.quote(nil)
          else
            value.map { |v| c.quote(v) }.join(',')
          end
        else
          c.quote(value)
        end
      end
    end
  end
end
