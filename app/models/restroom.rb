class Restroom < ApplicationRecord
    validates :name, uniqueness: true
    validates :neighborhood_id, presence: true

    belongs_to :neighborhood

    has_many :ratings
    has_many :users, :through => :ratings

    has_many :restroom_tags
    has_many :tags, :through => :restroom_tags

    accepts_nested_attributes_for :tags, reject_if: proc { |attributes| attributes['description'].blank? || Tag.find_by(description: attributes['description'])}, :allow_destroy => true

    def average_rating
        self.ratings_total/(ratings.size)
    end

    def ratings_total
        ratings.inject do |sum, rating|
            sum + rating.value
        end
    end

    def rating_quantity
        self.ratings.size
    end
end
