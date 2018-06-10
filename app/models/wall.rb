class Wall < ApplicationRecord
  belongs_to :user
  has_many :video_posts, dependent: :destroy
  has_many :text_posts, dependent: :destroy
  has_many :picture_posts, dependent: :destroy
end
