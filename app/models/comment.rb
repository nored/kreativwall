class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :picture_post
  belongs_to :video_post
  belongs_to :text_post
end
