class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.inet :ip

      t.timestamps
    end
  end
end
