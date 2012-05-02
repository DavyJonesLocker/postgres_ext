class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.inet :ip, :null => false
      t.cidr :subnet

      t.timestamps
    end
  end
end
