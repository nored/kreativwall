class PicturePost < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :user
  belongs_to :wall
  mount_base64_uploader :contend, PictureUploader
end
