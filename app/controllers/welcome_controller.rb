class WelcomeController < ApplicationController
    # redirect if logged in
    def home
        redirect_to restrooms_path if logged_in?
    end
end