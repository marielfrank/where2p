class RestroomsController < ApplicationController
    before_action :set_restroom, only: [:show, :edit, :update, :destroy]

    def index
        @restrooms = Restroom.all
    end

    def new
        @restroom = Restroom.new
        @location = Location.new
    end

    def create
        @restroom = Restroom.new(restroom_params)
        if @restroom && @restroom.save
            redirect_to restroom_path(@restroom)
        else
            redirect_to new_restroom_path, flash: {message: @restroom.errors.full_messages.join(", ")}
        end
    end

    def show
    end

    def edit
        @location = Location.new
    end

    def update
        if @restroom.update(restroom_params)
            redirect_to restroom_path(@restroom)
        else
            redirect_to edit_restroom_path, flash: {message: @restroom.errors.full_messages.join(", ")}
        end
    end

    def destroy
    end

    private

    def set_restroom
        Restroom.find_by(id: params[:id])
    end

    def restroom_params
        params.require(:restroom).permit(:name, :location_id, :location_attributes[:name], :tag_ids[], :tags_attributes[:description])
    end
end