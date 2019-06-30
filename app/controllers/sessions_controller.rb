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
      # Create an error message
      render 'new'
  end

  def destroy
  end
end
