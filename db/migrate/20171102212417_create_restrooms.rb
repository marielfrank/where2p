class CreateRestrooms < ActiveRecord::Migration[5.1]
  def change
    create_table :restrooms do |t|
      t.string :name
      t.string :address
      t.integer :neighborhood_id

      t.timestamps
    end
  end
end
