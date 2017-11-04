class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :address
      t.integer :neighborhood_id

      t.timestamps
    end
  end
end
