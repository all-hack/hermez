class AddCadetlistToListSelected < ActiveRecord::Migration[5.1]
  def change
    add_column :list_selecteds, :cadet_list, :string
  end
end
