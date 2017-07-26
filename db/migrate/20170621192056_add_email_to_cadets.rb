class AddEmailToCadets < ActiveRecord::Migration[5.1]
  def change
    add_column :cadets, :email, :string
  end
end
