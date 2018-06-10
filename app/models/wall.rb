class Wall < ApplicationRecord
  belongs_to :user
  has_many :video_posts
  has_many :text_posts
  has_many :picture_posts
end
