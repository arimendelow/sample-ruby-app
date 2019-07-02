class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])

    # Adds a 'byebug' prompt to the server terminal window, which we can issue commands to to figure out the state of the application
    # debugger # - Uncomment this for debugging
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # The 'log_in' function is in 'helpers/sessions_helper.rb'
      flash[:success] = "Welcome to Ari's Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update
    else
      render 'edit'
    end
  end

  private
    # Returns a version of the 'params' hash with ONLY the permitted attributes, and raises an error if the :user attribute is missing
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
