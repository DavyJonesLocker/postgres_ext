class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.inet :ip
      t.cidr :subnet, :subnet2
      t.integer :arrayzerd, :array => true
      t.inet :inet_arrayzerd, :array => true
      t.string :str_arrayzerd, :array => true, :limit => 5
      t.string :test

      t.timestamps
    end
  end
end
