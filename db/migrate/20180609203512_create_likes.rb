class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :video_post_id
      t.integer :text_post_id
      t.integer :picture_post_id

      t.timestamps
    end
  end
end
