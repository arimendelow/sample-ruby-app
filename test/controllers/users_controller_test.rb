require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:ari)
    @other_user = users(:hamm)
  end

  test "should redirect from index to login when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect from edit to login when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect from update to login when not logged in" do
    patch user_path(@user), params: {
      user: {
        name: @user.name,
        email: @user.email,
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect from edit to root when logged in as the wrong user" do
    log_in_as(@user)
    get edit_user_path(@other_user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect from update to root when logged in as the wrong user" do
    log_in_as(@user)
    patch user_path(@other_user), params: {
      user: {
        name: @other_user.name,
        email: @other_user.email,
      }
    }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
      user: {
        password: 'password',
        password_confirmation: 'password',
        admin: true,
      }
    }
    assert_not @other_user.admin?
  end
end
