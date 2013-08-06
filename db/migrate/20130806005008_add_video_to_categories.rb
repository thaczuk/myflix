class AddVideoToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :video_id, :integer
  end
end
