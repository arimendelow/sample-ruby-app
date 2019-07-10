class PasswordResetsController < ApplicationController
  before_action :get_user,    only: [:edit, :update]
  before_action :valid_user,  only: [:edit, :update]
  before_action :check_exp,   only: [:edit, :update] # Update case 1

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "There is no account for that email address"
      render 'new'
    end
  end

  def edit
  end

  # Four possible cases for the update action:
  #   1) Expired password reset
  #   2) Failed update due to invalid pass
  #   3) Failed update due to an empty password and confirmation - this one's tricky because it'll initially look successful
  #   4) Successful update (yay!)
  def update

  end

  private

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms that a user is valid
    def valid_user
      unless (
              @user &&
              @user.activated? &&
              @user.authenticated?(:reset, params[:id])
             )
        redirect_to root_url
      end
    end

    # Checks the expriration of the reset token
    def check_exp
      if @user.password_reset_expired?
        flash[:danger] = "This password reset link has expired, as it was sent over two hours ago."
        redirect_to new_password_reset_url
      end
    end

end
