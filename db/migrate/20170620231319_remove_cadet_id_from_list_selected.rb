class RemoveCadetIdFromListSelected < ActiveRecord::Migration[5.1]
  def change
    remove_column :list_selecteds, :cadet_id
  end
end
