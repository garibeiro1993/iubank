class CreateTransfers < ActiveRecord::Migration[6.0]
  def change
    create_table :transfers do |t|
      t.integer :amount, null: false
      t.integer :source_account_id, null: false
      t.integer :destination_account_id, null: false

      t.timestamps
    end
  end
end
