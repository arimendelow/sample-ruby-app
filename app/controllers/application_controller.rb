class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # Confirms a logged in user
    def logged_in_user
      unless logged_in?
        store_location # Store the website that the user is trying to access - this function is a sessions helper
        flash[:danger] = "You need to log in to access this page."
        redirect_to login_url
      end
    end

end
