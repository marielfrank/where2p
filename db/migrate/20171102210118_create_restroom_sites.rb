class CreateRestroomSites < ActiveRecord::Migration[5.1]
  def change
    create_table :restroom_sites do |t|
      t.string :address
      t.integer :neighborhood_id

      t.timestamps
    end
  end
end
