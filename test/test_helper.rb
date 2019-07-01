ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if a user is logged in
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Log in as a specific user
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest

  # Log in as a specific user - this is the version that will be called in integration tests
  # Same name as the other version of this method so that we can use code from a controller test in an integration without making changes to the login method
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: {
      session: {
        email: user.email,
        password: password,
        remember_me: remember_me,
      }
    }
  end
end
