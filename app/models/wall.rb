class Wall < ApplicationRecord
  belongs_to :user, required: false
  has_many :video_posts, dependent: :destroy
  has_many :text_posts, dependent: :destroy
  has_many :picture_posts, dependent: :destroy
  validates :name, presence:true
  validates :slug, presence:true, uniqueness: true
end
