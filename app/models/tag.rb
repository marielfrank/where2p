class Tag < ApplicationRecord
    validates :description, presence: true, uniqueness: true
    has_many :restroom_tags
    has_many :restrooms, :through => :restroom_tags
end
