class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  validates :stock_id, uniqueness: { scope: :user_id }

  # Garante que, se o usuário não preencher, os valores sejam 0, não nil
  after_initialize :set_defaults, if: :new_record?

  def total_cost
    (units || 0) * (average_price || 0)
  end
  
  def market_value
    (units || 0) * (stock.last_price || 0)
  end

  def profit_loss_amount
    market_value - total_cost
  end
  
  def profit_loss_percent
    return 0 if (average_price.nil? || average_price.zero?)
    
    ((stock.last_price - average_price) / average_price) * 100
  end
  
  private
  
  def set_defaults
    self.units ||= 0.0
    self.average_price ||= 0.0
  end
end