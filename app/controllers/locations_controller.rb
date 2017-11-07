class LocationsController < ApplicationController
    before_action :set_location, only: [:show, :edit, :update, :destroy]

    def new
        @location = Location.new
    end

    def create
        @location = Location.new(location_params)
        if @location && @location.save
            redirect_to location_path(@location)
        else
            redirect_to new_location_path, flash: {message: @location.errors.full_messages.join(", ")}
        end
    end

    def show
    end

    def edit
    end

    def update
        if @location.update(location_params)
            redirect_to location_path(@location)
        else
            redirect_to edit_location_path, flash: {message: @location.errors.full_messages.join(", ")}
        end
    end

    def destroy
        @location.delete
    end

    private

    def set_location
        Location.find_by(id: params[:id])
    end

end