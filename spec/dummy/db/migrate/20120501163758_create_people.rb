class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.inet :ip
      t.cidr :subnet
      t.integer :tag_ids, :array => true
      t.string :tags, :array => true

      t.timestamps
    end
  end
end
