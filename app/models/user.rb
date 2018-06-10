class User < ApplicationRecord
  has_many :walls, dependent: :destroy
  has_many :video_posts, dependent: :destroy
  has_many :text_posts, dependent: :destroy
  has_many :picture_posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  mount_base64_uploader :picture, PictureUploader

  # Assign an API key on create
  before_create do |user|
    user.api_key = user.generate_api_key
  end

  # Generate a unique API key
  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end

end
