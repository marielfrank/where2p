class SessionsController < ApplicationController
    # redirect user if already logged in
    def new
        redirect_to restrooms_path if logged_in?
    end

    # allow login through Google oauth or form signup
    def create
        # check if env['omniauth.auth'] has a value, i.e., Google authenticated user 
        if auth
            # ensure no duplicates of user are created from oauth
            @user = User.find_or_create_by(uid: auth['uid']) do |u|
                u.name = auth['info']['name']
                u.email = auth['info']['email']
                # set random secure password if new user
                u.password ||= SecureRandom.base58
            end
            # call log in method
            log_user_in
        else
            # find user by email
            @user = User.find_by(email: params[:user][:email])
            # ensure user exists and can be authenticated
            if @user && @user.authenticate(params[:user][:password])
                # call log in method
                log_user_in
            else
                # flash errors with 'fields_with_errors' highlighting fields in question
                flash[:message] = "Oops! Please provide a valid email address and password."
                render 'sessions/new'
            end
        end
    end

    # log out & redirect to homepage
    def destroy
        session.clear
        redirect_to root_path
    end

    private

    # authorize user through Google oauth
    def auth
        request.env['omniauth.auth']
    end
end