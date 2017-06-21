class CreateListSelecteds < ActiveRecord::Migration[5.1]
  def change
    create_table :list_selecteds do |t|
      t.integer :cadet_count

      t.timestamps
    end
  end
end
