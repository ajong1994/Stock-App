class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :transactions
  validates :email, uniqueness: true,
                  presence: true
  validates :password, length: {minimum: 8}
  validates :full_name, uniqueness: true,
                      presence: true
end
