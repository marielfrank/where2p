class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.integer :value
      t.integer :restroom_id
      t.integer :user_id

      t.timestamps
    end
  end
end
