class RatingsController < ApplicationController
    before_action :set_restroom
    before_action :require_login, only: [:create, :update, :destroy]

    def index
        if params[:restroom_id]
            @rating = @restroom.ratings.build(user_id: current_user.id)
            @ratings = @restroom.ratings
        else
            @ratings = Rating.all
        end
    end

    def create
        @rating = @restroom.ratings.build(rating_params)
        if @rating && @rating.save
            redirect_to restroom_ratings_path(@restroom)
        else
            @ratings = @restroom.ratings
            flash[:message] = flash_error(@rating)
            render 'ratings/index'
        end
    end

    def update
    end

    def destroy
    end

    private

    def rating_params
        params.require(:rating).permit(:restroom_id, :user_id, :value, :comment)
    end
end