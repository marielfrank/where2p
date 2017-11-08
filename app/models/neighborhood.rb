class Neighborhood < ApplicationRecord
    validates :name, presence: true, uniqueness: true

    has_many :restrooms
end
