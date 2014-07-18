class CTEProxy
  include ActiveRecord::Querying
  include ActiveRecord::Sanitization::ClassMethods
  include ActiveRecord::Reflection::ClassMethods

  attr_accessor :reflections, :current_scope
  attr_reader :connection, :arel_table

  def initialize(name, model)
    @name = name
    @arel_table = Arel::Table.new(name)
    @model = model
    @connection = model.connection
    @_reflections = {}
  end

  def name
    @name
  end

  def table_name
    name
  end

  def column_names
    @model.column_names
  end

  def columns_hash
    @model.columns_hash
  end

  def model_name
    @model.model_name
  end

  def primary_key
    @model.primary_key
  end

  def attribute_alias?(*args)
    @model.attribute_alias?(*args)
  end

  def aggregate_reflections(*args)
    @model.aggregate_reflections(*args)
  end

  def instantiate(record, column_types = {})
    @model.instantiate(record, column_types)
  end

  private

  def reflections
    @_reflections
  end

  alias _reflections reflections
end
