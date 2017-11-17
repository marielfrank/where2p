class SessionsController < ApplicationController

    def new
        redirect_to restrooms_path if logged_in?
    end

    def create
        if auth
            @user = User.find_or_create_by(uid: auth['uid']) do |u|
                u.name = auth['info']['name']
                u.email = auth['info']['email']
                u.password ||= SecureRandom.base58
            end
            log_user_in
        else
            @user = User.find_by(email: params[:user][:email])
            if @user && @user.authenticate(params[:user][:password])
                log_user_in
            else
                flash[:message] = "Oops! Please provide a valid email address and password."
                render 'sessions/new'
            end
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

    def auth
        request.env['omniauth.auth']
    end

    def log_user_in
        session[:user_id] = @user.id
        redirect_to restrooms_path, flash: {message: "Welcome, #{@user.name}!"}
    end
end