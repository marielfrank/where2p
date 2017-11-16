class NeighborhoodsController < ApplicationController
    before_action :set_neighborhood, only: [:show, :edit, :update, :destroy]
    before_action :require_admin, only: [:create, :edit, :update, :destroy]

    def index
        @neighborhoods = Neighborhood.all
        @neighborhood = Neighborhood.new
    end

    def create
        @neighborhood = Neighborhood.new(neighborhood_params)
        if @neighborhood && @neighborhood.save
            redirect_to neighborhood_path(@neighborhood)
        else
            flash[:message] = flash_error(@neighborhood)
            render 'neighborhoods/new'
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
            flash[:message] = flash_error(@neighborhood)
            render 'neighborhoods/edit'
        end
    end

    def destroy
        name = @neighborhood.name
        @neighborhood.delete
        redirect_to neighborhoods_path, flash: {message: "#{name} has been deleted."}
    end

    private

    def set_neighborhood
        @neighborhood = Neighborhood.find_by(id: params[:id])
    end

    def neighborhood_params
        params.require(:neighborhood).permit(:name)
    end

end