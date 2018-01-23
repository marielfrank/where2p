class RatingsController < RestroomsController
    # set variables and require login before certain actions
    before_action :set_rating, only: [:edit, :update, :destroy]
    before_action :set_restroom
    before_action :require_login, except: [:index]

    def index
        # ensure ratings have an associated restroom
        if params[:restroom_id]            
            # build new rating for form if user is logged in
            @rating = @restroom.ratings.build(user_id: current_user.id) if logged_in?
            # set ratings variable for current restroom
            @ratings = @restroom.ratings
            respond_to do |format|
                format.html { render 'index' }
                format.json { render json: @ratings }
            end
        else
            # redirect if no associated restroom
            redirect_to restrooms_path
        end
    end

    def create
        # build rating from strong params
        @rating = @restroom.ratings.build(rating_params)
        # make sure rating isn't nil and can be saved
        if @rating && @rating.save
            # redirect with success message
            redirect_to restroom_ratings_path(@restroom)
        else
            # render form errors & error messages
            @ratings = @restroom.ratings
            display_errors(@rating, 'ratings/index')
        end
    end

    def edit
        # make sure user is owner of rating or an admin
        if !current_user.owner_or_admin?(@rating)
            redirect_to restroom_ratings_path(@restroom), flash: {message: "You don't have permission to edit another user's rating."}
        end
        @user = @rating.user
    end

    def update
        og_user = @rating.user
        # make sure rating can be updated with strong params
        if @rating.update(rating_params)
            @rating.update(user: og_user)
            # redirect with success message
            redirect_to restroom_ratings_path(@restroom), flash: {message: "Rating has been updated."}
        else
            # render form errors & error messages
            display_errors(@rating, 'ratings/edit')
        end
    end

    def destroy
        # delete rating & redirect with success message
        @rating.delete
        redirect_to restroom_ratings_path(@restroom), flash: {message: "Rating has been deleted."}
    end

    private
    # set rating variable based on id in params
    def set_rating
        @rating = Rating.find(params[:id])
    end

    # set restroom variable based on restroom_id in params
    def set_restroom
        @restroom = Restroom.find(params[:restroom_id])
    end

    # use strong params
    def rating_params
        params.require(:rating).permit(:restroom_id, :user_id, :stars, :comment)
    end
end