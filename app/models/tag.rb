class Tag < ApplicationRecord
    # make sure description is present & unique
    validates :description, presence: true, uniqueness: true

    # add associations
    has_many :restroom_tags
    has_many :restrooms, :through => :restroom_tags
end
