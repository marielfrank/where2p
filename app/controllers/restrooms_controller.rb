class RestroomsController < ApplicationController
    # set variables and require login access before certain actions
    before_action :set_restroom, only: [:show, :edit, :update, :destroy]
    before_action :require_login, except: [:index, :show, :top_five]

    # load restrooms as instance variable
    def index
        @restrooms = Restroom.all
    end

    # load restrooms as instance variable
    def top_five
        @restrooms = Restroom.top_5
    end

    # build new restroom for form
    def new
        @restroom = Restroom.new
    end

    def create
        # attempt to create restroom using strong params
        @restroom = Restroom.new(restroom_params)
        if @restroom && @restroom.save
            # redirect with success message
            redirect_to restroom_path(@restroom), flash: {message: "#{@restroom.name} has been created."}
        else
            # flash errors with 'fields_with_errors' highlighting fields in question
            flash[:message] = flash_error(@restroom)
            render 'restrooms/new'
        end
    end

    def show
    end

    def edit
    end

    def update
        # attempt to update restroom using strong params
        # byebug
        if @restroom.update(restroom_params) && @restroom.errors.empty?
            # redirect with success message
            redirect_to restroom_path(@restroom), flash: {message: "#{@restroom.name} has been updated."}
        else
            # flash errors with 'fields_with_errors' highlighting fields in question
            flash[:message] = flash_error(@restroom)
            render 'restrooms/edit'
        end
    end

    # delete & redirect with success message
    def destroy
        name = @restroom.name
        @restroom.delete
        redirect_to restrooms_path, flash: {message: "#{name} has been deleted."}
    end

    private
    # set restroom variable based on id in params
    def set_restroom
        @restroom = Restroom.find(params[:id])
    end

    # use strong params
    def restroom_params
        params.require(:restroom).permit(:name, :address, :neighborhood_id, tag_ids: [], tags_attributes: [:description], ratings_attributes: [:user_id, :value, :comment])
    end
end