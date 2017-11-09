class UsersController < ApplicationController

    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def new
        redirect_to restrooms_path if logged_in?
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user && @user.save
            session[:user_id] = @user.id
            redirect_to restrooms_path, flash: {message: "Welcome, #{current_user.name}!"}
        else
            flash[:message] = flash_error(@user)
            render 'users/new'
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
            flash[:message] = flash_error(@user)
            render 'users/edit'
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