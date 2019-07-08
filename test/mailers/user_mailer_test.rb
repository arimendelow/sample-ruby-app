require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  # This test throws the following error: "ActionView::Template::Error: Missing host to link to! Please provide the :host parameter, set default_url_options[:host], or set :only_path to true"
  # even though we DO set that host URL. Need to look more into why it's thrown. Per Google, seems to be a widespread issue. Commenting out, for now.
  test "account_activation" do
    user = users(:ari)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account Activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    # CGI.escape converts the input into URL friendly characters
    assert_match CGI.escape(user.email),   mail.body.encoded
  end

  test "password_reset" do
    mail = UserMailer.password_reset
    assert_equal "Password reset", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
