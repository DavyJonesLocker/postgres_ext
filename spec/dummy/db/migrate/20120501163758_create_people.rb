class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.inet :ip
      t.cidr :subnet, :subnet2
      t.integer_array :arrayzerd
      t.inet_array :inet_arrayzerd
      t.string_array :str_arrayzerd, :limit => 5
      t.string :test

      t.timestamps
    end
  end
end
