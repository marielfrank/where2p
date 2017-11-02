class Rating < ApplicationRecord
    validates :value, presence: true

    belongs_to :restroom
    belongs_to :user
end
