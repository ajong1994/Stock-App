class CreateCurrentStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :current_stocks, id: :uuid do |t|
      t.string :security_symbol, null:false
      t.string :security_name, null:false
      t.integer :quantity, null:false
      t.decimal :total_security_cost, null:false
      t.references :user, type: :uuid, null:false
      t.timestamps
    end
  end
end
