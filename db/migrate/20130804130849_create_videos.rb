class CreateVideos < ActiveRecord::Migration
  def up
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :small_cover_url
      t.string :large_cover_url

      t.timestamps
    end
  end

  def down
    drop_table :videos
  end
end
