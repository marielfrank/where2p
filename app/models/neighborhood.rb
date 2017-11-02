class Neighborhood < ApplicationRecord
    validates :name, presence: true, uniqueness: true

    has_many :addresses
    has_many :restrooms, :through => :addresses
end
