module RatingsHelper
    def no_ratings
        if logged_in?
            "Be the first to rate this restroom!"
        else
            "This restroom hasn't been rated yet"
        end
    end
end