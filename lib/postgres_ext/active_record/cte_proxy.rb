class CTEProxy
  include ActiveRecord::Querying
  include ActiveRecord::Sanitization::ClassMethods
  include ActiveRecord::Reflection::ClassMethods

  attr_accessor :reflections
  attr_reader :connection, :arel_table

  def initialize(name, model)
    @name = name
    @arel_table = Arel::Table.new(name)
    @model = model
    @connection = model.connection
    @reflections = {}
  end

  def name
    @name
  end

  def column_names
    @model.column_names
  end

  def columns_hash
    @model.columns_hash
  end
end

