class WelcomeController < ApplicationController
    def home
        redirect_to restrooms_path if logged_in?
    end
end