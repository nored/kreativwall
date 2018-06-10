class CreateWalls < ActiveRecord::Migration[5.2]
  def change
    create_table :walls do |t|
      t.string :name
      t.string :slug
      t.datetime :expireDate
      t.integer :user_id

      t.timestamps
    end
  end
end
