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
        if admin?
            true
        elsif resource.respond_to?('user')
            resource.user == self
        else
            false
        end
    end

    # find or create by oauth user_id
    def self.set_user_from_oauth(auth)
        find_or_create_by(uid: auth['uid']) do |u|
            u.name = auth['info']['name']
            u.email = auth['info']['email']
            # set random secure password if new user
            u.password ||= SecureRandom.base58
        end
    end

    # rating for restroom
    def rating_for(restroom)
        !!self.ratings.where(restroom: restroom).last ? self.ratings.where(restroom: restroom).last.stars : "You haven't rated this restroom yet."
    end

    # reset user position
    def reset_position
        self.update(current_lat: nil, current_lng: nil)
    end
end
