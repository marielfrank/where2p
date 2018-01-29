class AddDurationAndDistanceToRestroom < ActiveRecord::Migration[5.1]
  def change
    add_column :restrooms, :duration, :string
    add_column :restrooms, :distance, :string
  end
end
