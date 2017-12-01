class NeighborhoodsController < ApplicationController
    # set variables and require admin access before certain actions
    before_action :set_neighborhood, only: [:show, :edit, :update, :destroy]
    before_action :require_admin, only: [:create, :edit, :update, :destroy]

    # load neighborhoods as instance variable & build new neighborhood for 'new' form
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
            display_errors(@neighborhood, 'neighborhoods/index')
        end
    end

    def show
    end

    def edit
    end

    def update
        # attempt to update neighborhood using strong params
        if @neighborhood.update(neighborhood_params)
            # redirect with success message
            redirect_to neighborhood_path(@neighborhood), flash: {message: "#{@neighborhood.name} has been updated."}
        else
            # flash errors with 'fields_with_errors' highlighting fields in question
            display_errors(@neighborhood, 'neighborhoods/edit')
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
    # set neighborhood variable based on id in params
    def set_neighborhood
        @neighborhood = Neighborhood.find_by(id: params[:id])
    end

    # use strong params
    def neighborhood_params
        params.require(:neighborhood).permit(:name)
    end

end