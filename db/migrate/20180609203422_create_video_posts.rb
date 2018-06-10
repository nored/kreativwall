class CreateVideoPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :video_posts do |t|
      t.string :contend
      t.integer :user_id
      t.integer :wall_id

      t.timestamps
    end
  end
end
