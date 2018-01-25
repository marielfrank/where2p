class AddCurrentLatAndCurrentLngToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :current_lat, :string
    add_column :users, :current_lng, :string
  end
end
