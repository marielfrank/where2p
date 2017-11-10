class User < ApplicationRecord
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    has_secure_password
    
    has_many :ratings
    has_many :restrooms, :through => :ratings

    def admin?
        self.admin
    end
end
