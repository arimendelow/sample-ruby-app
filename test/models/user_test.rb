require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  # Called before every single test - 'teardown' is called every every test
  def setup
    @user = User.new(name: "Example User", email: "test@email.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
    @user.name = "Example User"
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "email should be a valid email structure" do
    @user.email = "missing at sign, has spaces, missing the domain extention"
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@test.com"
    assert_not @user.valid?
  end
end
