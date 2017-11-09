class RatingsController < ApplicationController
    def index
        if params[:restroom_id]
            @restroom = set_restroom
            @rating = @restroom.ratings.build(user_id: current_user.id)
            @ratings = @restroom.ratings
        else
            @ratings = Rating.all
        end
    end

    def create
        @restroom = set_restroom
        @rating = @restroom.ratings.build(rating_params)
        if @rating && @rating.save
            redirect_to restroom_ratings_path(@restroom)
        else
            @ratings = @restroom.ratings
            flash[:message] = flash_error(@rating)
            render 'ratings/index'
        end
    end

    private
    def set_restroom
        Restroom.find(params[:restroom_id])
    end

    def rating_params
        params.require(:rating).permit(:restroom_id, :user_id, :value, :comment)
    end
end