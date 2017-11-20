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
    def tags_attributes=(tag_attributes)
        tag_attributes.values.each do |attr|
            tag = Tag.find_or_create_by(attr)
            self.restroom_tags.build(tag: tag) if !self.tags.include?(tag) && !!tag.description
        end
    end
    
    # scope method for top 5 restrooms based on average rating
    def self.top_5
        self.all.sort_by do |rest|
            rest.ratings_quantity > 0 ? rest.average_rating : 0
        end.reverse.first(5)
    end

    # get restroom's average rating
    def average_rating
        ratings_total/(ratings_quantity).to_f
    end

    # average rating helper
    def ratings_total
        vals = ratings.collect{ |rat| rat.value }
        vals.inject do |sum, val|
            sum + val
        end
    end

    # average rating helper & used in ratings#index view
    def ratings_quantity
        self.ratings.any? {|rat| rat.id == nil } ? self.ratings.size - 1 : self.ratings.size
    end

end
