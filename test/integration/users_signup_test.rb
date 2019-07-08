require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  test "valid signup information" do
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
    follow_redirect!
    # assert_template 'users/show'
    # assert is_logged_in?
  end
end
