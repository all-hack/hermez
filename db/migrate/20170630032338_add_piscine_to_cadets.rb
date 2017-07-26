class AddPiscineToCadets < ActiveRecord::Migration[5.1]
  def change
    add_column :cadets, :piscine, :bool
  end
end
