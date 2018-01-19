class RestroomSerializer < ActiveModel::Serializer
  attributes :name, :address, :tags, :neighborhood
end
