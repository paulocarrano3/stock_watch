class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  # --- ADICIONE ESTA LINHA ---
  validates :stock_id, uniqueness: { scope: :user_id }
  # ---------------------------
end
