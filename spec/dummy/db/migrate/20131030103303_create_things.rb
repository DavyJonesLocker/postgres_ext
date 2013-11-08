class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.string :name, unique: true
      t.string :title, null: false

      t.timestamps
    end
  end
end
