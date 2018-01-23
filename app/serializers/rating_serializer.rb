class RatingSerializer < ActiveModel::Serializer
  attributes :id, :stars, :restroom, :comment, :user
end
