require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  # Called before every single test - 'teardown' is called every every test
  def setup
    @user = User.new(name: "Example User", email: "test@email.com", password: "foobarba", password_confirmation:"foobarba")
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

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@test.com USER@bar.CO A-e_mm123@foo.bar.biz first.last@man.jp pat+pam@baz.co.il]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user.@test.com .user@test.com user@@test.com user@test,com USERbar.CO foo@bar..com foo@-bar.com foo@.bar.com A-e_mm123@foo.bar. first.last@ @baz.co.il pat+pam@baz+bar.co.il]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email validation should reject an invalid email structure" do
    @user.email = "missing at sign, has spaces, missing the domain extention"
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 255 + "@test.com"
    assert_not @user.valid?
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved in lowercase" do
    mixed_case_email = "uSeR@TEst.cOM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password shouldn't be blank" do
    @user.password = @user.password_confirmation = " " * 10
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do 
    assert_not @user.authenticated?(:remember, '')
  end
end
