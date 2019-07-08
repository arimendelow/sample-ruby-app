class UsersController < ApplicationController
  # Restrict the filters to act only on the :edit and :update actions
  before_action :logged_in_user,  only: [:edit, :update, :index, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,    only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

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
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please follow the link in your email to activate your account."
      redirect_to root_url
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
      flash[:success] = "Profile Updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user_name = User.find(params[:id]).name
    User.find(params[:id]).destroy
    flash[:success] = "User #{user_name} deleted."
    redirect_to users_url
  end

  private
    # Returns a version of the 'params' hash with ONLY the permitted attributes, and raises an error if the :user attribute is missing
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters - for using with the 'before_action' command 
    # to arrange for a particular method to be called before the given actions
    def logged_in_user
      unless logged_in?
        store_location # Store the website that the user is trying to access - this function is a sessions helper
        flash[:danger] = "You need to log in to access this page."
        redirect_to login_url
      end
    end

    # For making sure that a user is only trying to edit himself
    def correct_user
      @user = User.find(params[:id])
      # In addition to the syntax in the above method, if we're only running one command we can put the 'unless' statement on a single line
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
