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

  # Returns the user corresponding to either the current session, or the remember token cookie
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the current user is logged in, and false otherwise
  def logged_in?
    !current_user.nil?
  end

  # Returns true if the given user is the current user
  def current_user?(user)
    user == current_user
  end

  # Forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user
  def log_out
    forget current_user
    session.delete(:user_id)
    @current_user = nil
  end

  # Stores the location trying to be accessed
  def store_location
    # Only store get requests
    session[:forwarding_url] = request.original_url if request.get?
  end

  # Redirects to the stored location (or to the default)
  def redirect_back_or_to(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
