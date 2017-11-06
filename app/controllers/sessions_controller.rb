class SessionsController < ApplicationController

    def new
        redirect_to restrooms_path if logged_in?
        @user = User.new
    end

    def create
        @user = User.find_by(email: params[:user][:email])
        if @user && @user.authenticate(params[:user][:password])
            session[:user_id] = @user.id
            redirect_to restrooms_path
        else
            redirect_to login_path
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
end