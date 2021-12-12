class Transaction < ApplicationRecord
    belongs_to :user



    t.string :transaction_type, null:false
    t.string :security_symbol, null:false
    t.integer :quantity, null:false
    t.decimal :security_price, null:false
    t.decimal :total_security_cost, null:false
    t.integer :user_id, null:false
end
