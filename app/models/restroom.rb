class Restroom < ApplicationRecord
    # make sure name is unique and neighborhood has been selected
    validates :name, uniqueness: true
    validates :neighborhood_id, presence: true

    # add associations
    belongs_to :neighborhood

    has_many :ratings
    has_many :users, :through => :ratings

    has_many :restroom_tags
    has_many :tags, :through => :restroom_tags

    # allow restroom to build tag if tag description is present & unique
    accepts_nested_attributes_for :tags, reject_if: proc { |attributes| attributes['description'].blank? || Tag.find_by(description: attributes['description'])}, :allow_destroy => true
    
    # scope method for top 5 restrooms based on average rating
    def self.top_5
        self.all.sort_by do |rest|
            rest.ratings_quantity > 0 ? rest.average_rating : 0
        end.reverse.first(5)
    end

    # method to get restroom's average rating
    def average_rating
        ratings_total/(ratings_quantity)
    end

    # average rating helper
    def ratings_total
        vals = ratings.collect{ |rat| rat.value }
        vals.inject do |sum, val|
            sum + val
        end
    end

    # average rating helper
    def ratings_quantity
        self.ratings.size
    end
end
