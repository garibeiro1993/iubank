class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.integer :balance, null: false
      t.string :email, null: false
      t.string :password_digest

      t.timestamps
    end
  end
end
