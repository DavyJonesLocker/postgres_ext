require 'active_record/querying'

class CTEProxy
  include ActiveRecord::Querying
  include ActiveRecord::Sanitization::ClassMethods
  include ActiveRecord::Reflection::ClassMethods

  attr_accessor :reflections
  attr_reader :connection, :arel_table

  def initialize(name, connection)
    @name = name
    @arel_table = Arel::Table.new(name)
    @connection = connection
    @reflections = {}
  end

  def name
    @name
  end
end

module ActiveRecord::Querying
  delegate :with, :ranked, to: :all

  def from_cte(name, expression)
    table = Arel::Table.new(name)

    cte_proxy = CTEProxy.new(name, self.connection)
    relation = ActiveRecord::Relation.new cte_proxy, cte_proxy.arel_table
    relation.with name => expression
  end
end
