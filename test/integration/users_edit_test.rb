require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:ari)
  end

  test "failed edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        name: "",
        email: "foo@nope",
        password: "foo",
        password_confirmation: "bar",
      }
    }
    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "foo bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {
      user: {
        name: name,
        email: email,
        password: "",
        password_confirmation: "",
      }
    }
    # Make sure we get some message from 'flash'
    assert_not flash.empty?

    assert_redirected_to @user

    # Reload the user's values from the DB and confirm that they were successfully updated
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
