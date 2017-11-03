class Tag < ApplicationRecord
    validates :description, presence: true, uniqueness: true
    has_many :restaurant_tags
    has_many :restaurants, :through => :restaurant_tags
end
