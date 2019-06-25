require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "test@email.com")
    @user1 = User.new(name: "", email: "notemailstructure")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "should be invalid" do
    assert @user.invalid?
  end
end
