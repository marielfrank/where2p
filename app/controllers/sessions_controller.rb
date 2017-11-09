class SessionsController < ApplicationController

    def new
        redirect_to restrooms_path if logged_in?
        @user = User.new
    end

    def create
        if auth
            @user = User.find_or_create_by(uid: auth['uid']) do |u|
                u.name = auth['info']['name']
                u.email = auth['info']['email']
                u.password ||= SecureRandom.base58
            end
            session[:user_id] = @user.id
            redirect_to restrooms_path, flash: {message: "Welcome, #{current_user.name}!"}
        elsif User.find_by(email: params[:user][:email])
            @user = User.find_by(email: params[:user][:email])
            redirect_to login_path, flash: {message: flash_error(@user)} if !@user.authenticate(params[:user][:password])
            session[:user_id] = @user.id
            redirect_to restrooms_path, flash: {message: "Welcome, #{current_user.name}!"}
        else
            redirect_to login_path, flash: {message: "We weren't able to find a user by that email address..."}
        end
    end

    def destroy
        session.clear
        redirect_to root_path
    end

    private

    def set_session
        session.find_by(id: params[:id])
    end

    def session_params
        params.require(:session).permit(:name, :password, :email)
    end

    def auth
        request.env['omniauth.auth']
    end
end