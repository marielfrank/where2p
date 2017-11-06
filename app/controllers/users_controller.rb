class UsersController < ApplicationController
    before_action :
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def new
        @user = user.new
    end

    def create
        @user = user.new(user_params)
        if @user && @user.save
            session[:user_id] = @user.id
            redirect_to restrooms_path, flash: {message: "Your profile has been created."}
        else
            redirect_to new_user_path, flash: {message: @user.errors.full_messages.join(", ")}
        end
    end

    def show
    end

    def edit
    end

    def update
        if @user.update(user_params)
            redirect_to restrooms_path, flash: {message: "Your profile has been updated."}
        else
            redirect_to edit_user_path, flash: {message: @user.errors.full_messages.join(", ")}
        end
    end

    def destroy
    end

    private

    def set_user
        User.find_by(id: params[:id])
    end

    def user_params
        params.require(:user).permit(:name, :password, :email)
    end
end