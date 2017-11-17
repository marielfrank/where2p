class NeighborhoodsController < ApplicationController
    # set variables and require admin access before certain actions
    before_action :set_neighborhood, only: [:show, :edit, :update, :destroy]
    before_action :require_admin, only: [:create, :edit, :update, :destroy]

    # load neighborhoods as instance variable & create new neighborhood for 'new' form
    def index
        @neighborhoods = Neighborhood.all
        @neighborhood = Neighborhood.new
    end

    def create
        # attempt to create neighborhood using strong params
        @neighborhood = Neighborhood.new(neighborhood_params)
        if @neighborhood && @neighborhood.save
            # redirect with success message if save is successful
            redirect_to neighborhood_path(@neighborhood), flash: {message: "#{@neighborhood.name} has been successfully created."}
        else
            # flash errors with 'fields_with_errors' highlighting fields in question
            flash[:message] = flash_error(@neighborhood)
            render 'neighborhoods/index'
        end
    end

    def show
    end

    def edit
    end

    def update
        # attempt to update neighborhood using strong params
        if @neighborhood.update(neighborhood_params)
            # redirect with success message if udpate is successful
            redirect_to neighborhood_path(@neighborhood), flash: {message: "#{@neighborhood.name} has been updated."}
        else
            # flash errors with 'fields_with_errors' highlighting fields in question
            flash[:message] = flash_error(@neighborhood)
            render 'neighborhoods/edit'
        end
    end

    def destroy
        # ensure neighborhood isn't destroyed if contains restroom
        if @neighborhood.restrooms.empty?
            # if no restrooms, delete & redirect with success message
            name = @neighborhood.name
            @neighborhood.delete
            redirect_to neighborhoods_path, flash: {message: "#{name} has been deleted."}
        else
            # if any restrooms in neighborhood, redirect with flash message
            redirect_to neighborhood_path(@neighborhood), flash: {message: "#{@neighborhood.name} cannot been deleted until you first remove its restrooms."}
        end
    end

    private

    def set_neighborhood
        @neighborhood = Neighborhood.find_by(id: params[:id])
    end

    def neighborhood_params
        params.require(:neighborhood).permit(:name)
    end

end