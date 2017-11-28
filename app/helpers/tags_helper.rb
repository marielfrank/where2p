module TagsHelper
    # content for when no tags
    def no_tags
        if logged_in?
            "Be the first to tag this restroom!"
        else
            "This restroom hasn't been tagged yet."
        end
    end
end