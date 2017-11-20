class RestroomTag < ApplicationRecord
    belongs_to :restroom
    belongs_to :tag

    validates_presence_of :restroom, :tag
end
