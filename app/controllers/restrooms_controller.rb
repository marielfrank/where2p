class RestroomController < ApplicationController
    before_action :set_restroom, only: [:show, :edit, :update, :destroy]

    def index
        @restrooms = Restroom.all
    end

    def new
        @restroom = Restroom.new
    end

    def create
    end

    def show
    end

    def edit
    end

    def update
    end

    def destroy
    end

    private

    def set_restroom
        Restroom.find_by(id: params[:id])
    end

    def restroom_params
        params.require(:restroom).permit(:name, :location_id, :tag_ids[], :tags_attributes[:description])
    end
end