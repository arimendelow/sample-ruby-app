module SessionsHelper
  # "Logs in" the given user by storing their ID in rail's 'session' method
  # Places a temp cookie on the user's browser containing an encrypted version of the user's ID
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged in user
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # Returns true if the current user is logged in, and false otherwise
  def logged_in?
    !current_user.nil?
  end
end
