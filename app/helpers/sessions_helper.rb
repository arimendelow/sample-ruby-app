module SessionsHelper
  # "Logs in" the given user by storing their ID in rail's 'session' method
  # Places a temp cookie on the user's browser containing an encrypted version of the user's ID
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session
  def remember(user)
    user.remember
    # .permanent sets the 'expires' value to '20.years.from_now'
    # .signed encrypts the cookie before placing it on the browser
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
    # Once the cookies are set, we can retrieve the user with code such as:
    # User.find_by(id: cookies.signed[:user_id])
    # where cookies.signed[:user_id] automatically decrypts the user id cookie
    # Then, we can use bcrypt to verify that 'cookies[:remember_token]'
    # matches the 'remember_digest'
    # NOTE: we use both the ID and the remember token because the ID remains the same
    # on subsequent sessions, but the remember token expires. Therefore, without both,
    # someone with posession of the encrypted user ID would be able to log in as the user
    # forever and ever. With both, that person can only log in until the user logs out.
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

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
