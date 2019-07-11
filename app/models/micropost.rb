class Micropost < ApplicationRecord
  belongs_to :user
  # Make sure that each micropost is tied to a user
  validates :user_id, presence: true
end
