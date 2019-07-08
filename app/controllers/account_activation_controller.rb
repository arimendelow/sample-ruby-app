class AccountActivationController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    # If the user exists, but is not activated, and the correct activation token is passed in...
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      # Log the user in
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      # Otherwise, whatever was passed in as the activation token must not be correct, so notify the user
      flash[:danger] = "Invalid activation link :("
      redirect_to root_url
    end
  end
end
