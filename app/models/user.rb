class User < ApplicationRecord
  # Creates getter and setter methods corresponding to a user's 'remember_token'
  # This allows us to get and set a @remember_token instance variable
  attr_accessor :remember_token

  # Ensure that all emails are stored in lowercase
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }

  # A constant, indicated in Ruby by a name starting with a capital letter
  VALID_EMAIL_REGEX = /\A(\w+)([\w+\-.]+)(\w+)(@)([a-z\d]+)([a-z\d\-\.]+)([a-z\d]+)(\.)([a-z]+)\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } # Rails infirs that uniqueness should be true in addition to case insensitive

  # Explaining that email regex:
  # /             start of regex
  # \A            match start of string
  # \w+           at least one word character
  # [\w+\-.]+     at least one word character, plus a hyphen or dot
  # \w+           at least one word character
  # @             exactly one literal at sign
  # [a-z\d]+      at least one letter or digit
  # [a-z\d\-.]+   at least one letter, digit, hyphen, or dot
  # [a-z\d]+      at least one letter or digit
  # \.            exactly one literal dot
  # [a-z]+        at least one letter
  # \z            match end of string
  # /             end of regex
  # i             case insensitive
  #
  # Check here for regex rules: https://rubular.com

  # This method adds the following functionality:
  # - The ability to saved a hashed password_digest attribute to the database
  # - A pair of virtual attributes (password and password_confirmation), including presnce validations upon object creation and a validation requiring that they match
  # - An 'authenticate' method that returns the user when the password is correct (and 'false' otherwise)
  # The only requirement for this method to work is for the model to have an attribute called 'password_digest'
  has_secure_password
  # 'allow_nil: true' means that the password fields can be empty.
  # This both allows the update page to not require a user to enter their password,
  # and avoids a duplicate error message on the signup page of "password is missing"
  # as 'has_secure_password' already includes a seperate presence validation that specifically catches nil passwords
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  # Returns the hash digest of the given string using the minimum cost parameter in tests and a normal (high) cost parameter in production
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random base64 token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for user in persistent sessions (staying logged in when the window is closed)
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # For logging out a user
  def forget
    update_attribute(:remember_digest, nil)
  end
end
