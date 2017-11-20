class Rating < ApplicationRecord
    # make sure value is present
    validates :value, presence: true

    # add associations
    belongs_to :restroom
    belongs_to :user
end
