class neighborhoodsController < ApplicationController
    before_action :set_neighborhood, only: [:show, :edit, :update, :destroy]

    def new
        @neighborhood = Neighborhood.new
    end

    def create
        @neighborhood = Neighborhood.new(neighborhood_params)
        if @neighborhood && @neighborhood.save
            redirect_to neighborhood_path(@neighborhood)
        else
            redirect_to new_neighborhood_path, flash: {message: @neighborhood.errors.full_messages.join(", ")}
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
            redirect_to edit_neighborhood_path, flash: {message: @neighborhood.errors.full_messages.join(", ")}
        end
    end

    def destroy
        @neighborhood.delete
    end

    private

    def set_neighborhood
        Neighborhood.find_by(id: params[:id])
    end

end