class AddCurrentLocationToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :current_location, :string
  end
end
