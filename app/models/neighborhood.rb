class Neighborhood < ApplicationRecord
    # make sure name is present & unique
    validates :name, presence: true, uniqueness: true

    # add association
    has_many :restrooms
end
