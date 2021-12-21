class Transaction < ApplicationRecord
    belongs_to :user
    validates :transaction_type, presence: true
    validates :security_symbol, presence: true 
    validates :quantity, numericality: {greater_than: 0}
    validates :security_price, numericality: {greater_than: 0}
    validates :total_security_cost, numericality: {greater_than: 0}
    validates :user_id, presence: true
end
