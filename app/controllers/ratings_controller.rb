class RatingsController < RestroomsController
    before_action :set_rating, only: [:edit, :update, :destroy]
    before_action :set_restroom
    before_action :require_login

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

    def edit
    end

    def update
        if @rating.update(rating_params)
            redirect_to restroom_ratings_path(@restroom), flash: {message: "Rating has been updated."}
        else
            flash[:message] = flash_error(@rating)
            render 'ratings/edit'
        end
    end

    def destroy
        if @rating.user == current_user || current_user.admin?
            @rating.delete
            redirect_to restroom_ratings_path(@restroom), flash: {message: "Rating has been deleted."}
        else
            redirect_to restroom_ratings_path(@restroom), flash: {message: "You don't have permission to edit another user's rating."}
        end
    end

    private

    def set_rating
        @rating = Rating.find(params[:id])
    end

    def set_restroom
        @restroom = Restroom.find(params[:restroom_id])
    end

    def rating_params
        params.require(:rating).permit(:restroom_id, :user_id, :value, :comment)
    end
end