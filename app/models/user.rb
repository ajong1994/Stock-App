class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :transactions
  has_many :current_stocks
  validates :email, uniqueness: true,
                  presence: true
  validates :password, length: {minimum: 6}, unless: -> {password.nil?}
  validates :password, presence: true, if: -> {id.nil?}
  validates :full_name, uniqueness: true,
                      presence: true

  def admin?
    type == "Admin"
  end
end
