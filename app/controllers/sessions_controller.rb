class SessionsController < ApplicationController
  def new
  end

  def create
    # ':session' is a hash within the params hash with the keys 'email' and 'password'
    user = User.find_by(email: params[:session][:email].downcase)
    # If the user exists AND the password is correct...
    if user && user.authenticate(params[:session][:password])
      # Log in and redirect to the user's show page
    else
      # Use '.now', which is specifically designed for displaying flash messages on rendered pages
      # The contents of flash.now disappear as soon as there is an additional request
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
  end
end
