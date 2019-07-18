class AccountActivationController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    # If the user exists, but is not activated, and the correct activation token is passed in...
    $stdout.puts "user: #{!!user}"
    Rails.logger.debug "In the account_activation_controller.rb 'edit' action"
    Rails.logger.debug "User: #{user}; user.authenticated?: #{user.authenticated?(:activation, params[:id])}"
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      Rails.logger.info "Activating the user!"
      user.activate
      # Log the user in
      Rails.logger.info "Logging in the user!"
      log_in user
      flash[:success] = "Account activated!"
      Rails.logger.info "Redirecting to the user's profile!"
      redirect_to user
    # if the user IS already activated
    elsif user && user.activated?
      Rails.logger.info "User already activated!"
      if logged_in?
        flash[:info] = "Account already activated!"
        redirect_to root_url
      else
        flash[:warning] = "Account already activated, please log in!"
        redirect_to login_url
      end
    else
      Rails.logger.info "Something went wrong with the account activation."
      # Otherwise, whatever was passed in as the activation token must not be correct, so notify the user
      flash[:danger] = "Invalid activation link :("
      redirect_to root_url
    end
  end
end
