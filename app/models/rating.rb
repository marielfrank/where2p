class Rating < ApplicationRecord
    # make sure stars is present
    validates :stars, presence: true

    # add associations
    belongs_to :restroom
    belongs_to :user
end
