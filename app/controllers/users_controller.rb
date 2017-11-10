class UsersController < ApplicationController

    before_action :set_user, only: [:edit, :update, :destroy]
    authorize_resource
    skip_authorize_resource :only => [:new, :create]

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
        # redirect_to restrooms_path, flash: {message: "You don't have permission to edit that profile."} if @user != current_user
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
        # if @user == current_user
            name = @user.name
            User.delete(id: @user.id)
            redirect_to root_path, flash: {message: "Your profile has been deleted, #{name}. Sorry to see you go!"}
        # else
        #     redirect_to restrooms_path, flash: {message: "You don't have permission to delete that profile."}
        # end
    end

    private

    def set_user
        @user = User.find_by(id: params[:id])
    end

    def user_params
        params.require(:user).permit(:name, :password, :email, :admin)
    end
end