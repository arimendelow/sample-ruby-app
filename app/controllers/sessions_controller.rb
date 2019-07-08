class SessionsController < ApplicationController
  def new
  end

  def create
    # ':session' is a hash within the params hash with the keys 'email' and 'password'
    user = User.find_by(email: params[:session][:email].downcase)
    # If the user exists AND the password is correct...
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        # Rails converts 'user' to the route for the user's profile page (user_url(user))
        # 'log_in' and 'remember' are helper functions
        log_in user
        # Handle the submission of the 'remember me' checkbox on the login page
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or_to user # This is a sessions helper for forwarding users to the requested page after logging in
      else
        flash[:warning] = "Account not activated. Please check your email for the activation link."
        redirect_to root_url
    else
      # Use '.now', which is specifically designed for displaying flash messages on rendered pages
      # The contents of flash.now disappear as soon as there is an additional request
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
