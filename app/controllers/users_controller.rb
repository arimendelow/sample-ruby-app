class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])

    # Adds a 'byebug' prompt to the server terminal window, which we can issue commands to to figure out the state of the application
    # debugger # - Uncomment this for debugging
  end

  def new
  end
end
