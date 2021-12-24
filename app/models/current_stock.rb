class CurrentStock < ApplicationRecord
    belongs_to :user
    validates :security_name, :security_symbol, :quantity, :total_security_cost, :user_id,
                                                                                    presence: true
    validates :security_name, :security_symbol,
                            uniqueness: true
end
