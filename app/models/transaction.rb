class Transaction < ApplicationRecord
    belongs_to :user
    validates :transaction_type, :security_symbol, :quantity, :total_security_cost, :user_id,
                                                                                    presence: true
    validates :security_price, numericality: {greater_than: 0}
end
