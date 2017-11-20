class TagsController < ApplicationController
    # set variables and require admin access before certain actions
    before_action :require_admin, only: [:delete]
    before_action :set_tag, only: [:show, :delete]
    
    # load tags as instance variable
    def index
        @tags = Tag.all
    end

    def show
    end

    def destroy
        @tag.delete
    end

    private
    # set tag variable based on id in params
    def set_tag
        @tag = Tag.find_by(id: params[:id])
    end
end