class Restroom < ApplicationRecord
    validates :location_id, presence: true
    validates :name, uniqueness: true

    belongs_to :location
    delegate :neighborhood, :to => :location

    has_many :ratings
    has_many :users, :through => :ratings

    has_many :restaurant_tags
    has_many :tags, :through => :restaurant_tags

    def average_rating
        ratings.inject do |sum, rating|
            sum + rating.value
        end/(ratings.size)
    end

    def address
        location.address
    end
end
