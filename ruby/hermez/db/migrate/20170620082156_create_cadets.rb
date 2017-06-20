class CreateCadets < ActiveRecord::Migration[5.1]
  def change
    create_table :cadets do |t|
      t.string :name
      t.string :login
      t.datetime :last_mail
      t.integer :mails_received

      t.timestamps
    end
  end
end
