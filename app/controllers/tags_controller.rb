class TagsController < ApplicationController
    before_action :admin_only, only: [:delete]
    before_action :set_tag, only: [:show, :delete]
    
    def index
        @tags = Tag.all
    end

    def show
    end

    def delete
    end

    private

    def set_tag
        @tag = Tag.find_by(id: params[:id])
    end
end