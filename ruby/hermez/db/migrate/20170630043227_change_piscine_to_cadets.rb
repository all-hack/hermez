class ChangePiscineToCadets < ActiveRecord::Migration[5.1]
  def change
    change_column :cadets, :piscine, :bool, :default => true    
  end
end
