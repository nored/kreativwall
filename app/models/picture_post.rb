class PicturePost < ApplicationRecord
  has_many :comments
  has_many :likes
  belongs_to :user
  belongs_to :wall
  mount_base64_uploader :picture, PictureUploader
end
