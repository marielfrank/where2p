class User < ApplicationRecord
    # make sure name is present
    validates :name, presence: true
    # make sure email is present & unique
    validates :email, presence: true, uniqueness: true
    # use bcrypt for password security
    has_secure_password
    
    # add associations
    has_many :ratings
    has_many :restrooms, :through => :ratings

    # check if user is an admin
    def admin?
        self.admin
    end

    # check if user is admin or owner of a resource
    def owner_or_admin?(resource)
        admin? || resource.user == self
    end
end
