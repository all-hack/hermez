class AddImageUrlToCadets < ActiveRecord::Migration[5.1]
  def change
    add_column :cadets, :image_url, :string
  end
end
