class TagsController < ApplicationController
    def show
        @tag = Tag.find_by(id: params[:id])
    end
end