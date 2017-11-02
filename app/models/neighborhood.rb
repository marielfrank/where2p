class Neighborhood < ApplicationRecord
    validates :name, presence: true, uniqueness: true

    has_many :locations
    has_many :restrooms, :through => :locations
end
