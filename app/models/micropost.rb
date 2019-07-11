class Micropost < ApplicationRecord
  belongs_to :user
  # Order the microposts by most recent first
  # Could also do 'order('created_at DESC'), which is raw SQL
  # '->' is called a 'stabby lambda'
  # It takes in a block and returns a Proc, which can then be evaluated with the 'call' method
  default_scope -> { order(created_at: :desc) }
  # Make sure that each micropost is tied to a user
  validates :user_id, presence: true
  # Make sure that content is both not empty and does not exceed 140 characters
  validates :content, presence: true, length: { maximum: 140 }
end
