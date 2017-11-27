class ChangeRatingsValueToStars < ActiveRecord::Migration[5.1]
  def change
    rename_column :ratings, :value, :stars
  end
end
