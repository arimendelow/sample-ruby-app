require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    # Test that there is no difference in User.count before and after
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name:                   "",
          email:                  "user@invalid",
          password:               "short",
          password_confirmation:  "different"
        }
      }
    end
  end

  test "valid signup information with account activation" do
    get signup_path
    # Test that there is a difference of 1in User.count before and after
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name:                   "Test User",
          email:                  "user@example.com",
          password:               "password",
          password_confirmation:  "password"
        }
      }
    end
    # Verify that exactly 1 message was delivered
    assert_equal 1, ActionMailer::Base.deliveries.size
    # 'assigns' lets us access instance variables in the in the corresponding action
    user = assigns(:user)
    assert_not user.activated?

    # Try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?

    # Attempt to use an invalid authentication token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?

    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'nischt email')
    assert_not is_logged_in?

    # Valid token and email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?

    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
