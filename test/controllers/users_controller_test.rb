require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new_user" do
    get users_new_user_url
    assert_response :success
  end

end
