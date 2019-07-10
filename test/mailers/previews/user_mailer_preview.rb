# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    # The account_activation method requires a valid user object as an argument,
    # so we define a 'user' var equal to the first user in the dev db, and then pass it as an arg
    user = User.first
    # Necessary because the account activation templates need an account activation token, which is a virtual attribute, so the user from the db doesn't have one
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

end
