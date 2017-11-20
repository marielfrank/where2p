class UsersController < ApplicationController
    # set variables and require admin/login access before certain actions
    before_action :set_user, only: [:edit, :update, :destroy]
    before_action :require_admin, only: [:index]
    before_action :require_login, only: [:edit, :destroy]
    before_action :authorize_user, only: [:edit, :update, :destroy]

    # all users only visible to admin
    def index
        @users = User.all
    end

    def new
        # redirect user if already logged in
        redirect_to restrooms_path if logged_in?
        # build new user for form
        @user = User.new
    end

    def create
        # attempt to create user with strong params
        @user = User.new(user_params)
        if @user && @user.save
            # call log in method
            log_user_in
        else
            # flash errors with 'fields_with_errors' highlighting fields in question
            flash[:message] = flash_error(@user)
            render 'users/new'
        end
    end

    def edit
    end

    def update
        # attempt to update user with strong params
        if @user.update(user_params)
            redirect_to restrooms_path, flash: {message: "Your profile has been updated."}
        else
            # flash errors with 'fields_with_errors' highlighting fields in question
            flash[:message] = flash_error(@user)
            render 'users/edit'
        end
    end

    # delete user & redirect with success message
    def destroy
        name = @user.name
        @user.delete
        redirect_to root_path, flash: {message: "Your profile has been deleted, #{name}. Sorry to see you go!"}
    end

    private

    # set user based on id in params
    def set_user
        @user = User.find_by(id: params[:id])
    end

    # disallow users from modifying other users' account information
    def authorize_user
        redirect_to restrooms_path, flash: {message: "You don't have permission to make changes to another user's profile."} unless current_user.admin? || @user == current_user
    end

    # use strong params
    def user_params
        params.require(:user).permit(:name, :password, :email, :admin)
    end
end