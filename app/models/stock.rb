class Stock < ApplicationRecord
  # Nossas associações
  has_many :user_stocks
  has_many :users, through: :user_stocks

  # Nossas validações
  validates :ticker, presence: true
  validates :name, presence: true
end