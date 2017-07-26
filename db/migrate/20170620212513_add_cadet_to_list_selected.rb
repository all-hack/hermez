class AddCadetToListSelected < ActiveRecord::Migration[5.1]
  def change
    add_reference :list_selecteds, :cadet, foreign_key: true
  end
end
