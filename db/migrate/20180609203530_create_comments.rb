class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :user_id
      t.integer :video_post_id
      t.integer :text_post_id
      t.integer :picture_post_id

      t.timestamps
    end
  end
end
