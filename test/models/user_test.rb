require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
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

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
    @user.email = "test@email.com"
  end

  test "email should be a valid email structure" do
    @user.email = "missing at sign, has spaces, missing the domain extention"
    assert_not @user.valid?
    @user.email = "test@email.com"
  end
end
