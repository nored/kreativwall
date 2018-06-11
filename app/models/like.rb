class Like < ApplicationRecord
  belongs_to :user
  belongs_to :picture_post, required: false
  belongs_to :video_post, required: false
  belongs_to :text_post, required: false
end
