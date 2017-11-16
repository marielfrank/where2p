class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :update, :destroy]
    before_action :admin_only, only: [:index]
    before_action :require_login, only: [:edit, :destroy]

    def index
        @users = User.all
    end

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

    def edit
        redirect_to restrooms_path, flash: {message: "You do not have permission to edit this user's profile."} unless current_user == @user || current_user.admin?
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
        name = @user.name
        @user.delete
        redirect_to root_path, flash: {message: "Your profile has been deleted, #{name}. Sorry to see you go!"}
    end

    private

    def set_user
        @user = User.find_by(id: params[:id])
    end

    def authorize_user
        redirect_to restrooms_path, flash: {message: "You don't have permission to make changes to another user's profile."} unless current_user.admin? || @user == current_user
    end

    def user_params
        params.require(:user).permit(:name, :password, :email, :admin)
    end
end