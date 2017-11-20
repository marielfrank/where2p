class RestroomTag < ApplicationRecord
    # add associations
    belongs_to :restroom
    belongs_to :tag

    # disallow creation without valid restroom and tag
    validates_presence_of :restroom, :tag
end
