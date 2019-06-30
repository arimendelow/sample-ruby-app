require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    # Test that there is no difference in User.count before and after
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "short",
          password_confirmation: "different"
        }
      }
    end
  end
end
