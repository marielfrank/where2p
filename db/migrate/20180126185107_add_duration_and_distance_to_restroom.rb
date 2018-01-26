class AddDurationAndDistanceToRestroom < ActiveRecord::Migration[5.1]
  def change
    add_column :restrooms, :duration, :float
    add_column :restrooms, :distance, :float
  end
end
