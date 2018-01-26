class RestroomSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :tags, :neighborhood
end
