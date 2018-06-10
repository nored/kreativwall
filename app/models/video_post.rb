class VideoPost < ApplicationRecord
  has_many :comments
  has_many :likes
  belongs_to :user
  belongs_to :wall
end
