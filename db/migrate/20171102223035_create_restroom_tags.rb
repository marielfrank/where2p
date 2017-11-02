class CreateRestroomTags < ActiveRecord::Migration[5.1]
  def change
    create_table :restroom_tags do |t|
      t.integer :restroom_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
