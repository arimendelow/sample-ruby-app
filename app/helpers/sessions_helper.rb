module SessionsHelper
  # "Logs in" the given user by storing their ID in rail's 'session' method
  # Places a temp cookie on the user's browser containing an encrypted version of the user's ID
  def log_in(user)
    session[:user_id] = user.id
  end
end
