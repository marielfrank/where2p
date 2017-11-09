class AddCommentToRatings < ActiveRecord::Migration[5.1]
  def change
    add_column :ratings, :comment, :string
  end
end
