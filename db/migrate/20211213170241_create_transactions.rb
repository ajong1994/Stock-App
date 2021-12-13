class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_type, null:false
      t.string :security_symbol, null:false
      t.integer :quantity, null:false
      t.decimal :security_price, null:false
      t.decimal :total_security_cost, null:false
      t.references :user, type: :uuid, null:false
      t.timestamps
    end
  end
end