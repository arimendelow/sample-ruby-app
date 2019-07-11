class Micropost < ApplicationRecord
  belongs_to :user
  # Make sure that each micropost is tied to a user
  validates :user_id, presence: true
  # Make sure that content is both not empty and does not exceed 140 characters
  validates :content, presence: true, length: { maximum: 140 }
end
