class SessionsController < ApplicationController

    def new
        redirect_to restrooms_path if logged_in?
        @user = User.new
    end

    def create
        if auth[:uid]
            @user = User.find_or_create_by(uid: auth['uid']) do |u|
                u.name = auth['info']['name']
                u.email = auth['info']['email']
                u.password ||= SecureRandom.base58
            end
        else
            @user = User.find_by(email: params[:user][:email])
            if @user && @user.authenticate(params[:user][:password])
            else
                redirect_to login_path, flash: {message: flash_error(@user)}
            end
        end
        
        session[:user_id] = @user.id
        redirect_to restrooms_path, flash: {message: "Welcome, #{current_user.name}!"}
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