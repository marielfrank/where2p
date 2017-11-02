class Location < ApplicationRecord
    validates :address, presence: true
    
    has_many :restrooms
    belongs_to :neighborhood
end
