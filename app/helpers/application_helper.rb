module ApplicationHelper
    def no_resource(resource)
        if logged_in?
            "Be the first to add a #{resource} this restroom!"
        else
            "No one has added #{resource}s to this restroom yet. Sign in to add one!"
        end
    end
end
