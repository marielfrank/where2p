class Neighborhood < ApplicationRecord
    validates :name, presence: true, uniqueness: true

    has_many :restroom_sites
    has_many :restrooms, :through => :restroom_sites
end
