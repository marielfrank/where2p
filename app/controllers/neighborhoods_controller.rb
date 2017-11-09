class NeighborhoodsController < ApplicationController
    before_action :set_neighborhood, only: [:show, :edit, :update, :destroy]

    def index
        @neighborhoods = Neighborhood.all
        @neighborhood = Neighborhood.new
    end

    def create
        @neighborhood = Neighborhood.new(neighborhood_params)
        if @neighborhood && @neighborhood.save
            redirect_to neighborhood_path(@neighborhood)
        else
            redirect_to new_neighborhood_path, flash: {message: flash_error(@neighborhood)}
        end
    end

    def show
    end

    def edit
    end

    def update
        if @neighborhood.update(neighborhood_params)
            redirect_to neighborhood_path(@neighborhood)
        else
            redirect_to edit_neighborhood_path, flash: {message: flash_error(@neighborhood)}
        end
    end

    def destroy
        @neighborhood.delete
    end

    private

    def set_neighborhood
        @neighborhood = Neighborhood.find_by(id: params[:id])
    end

    def neighborhood_params
        params.require(:neighborhood).permit(:name)
    end

end