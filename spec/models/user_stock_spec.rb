require 'rails_helper'

RSpec.describe UserStock, type: :model do
  # --- SETUP ---
  # Precisamos de "peças de Lego" válidas para construir nosso UserStock
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:stock) { Stock.create!(ticker: 'TEST', name: 'Test Stock', last_price: 100) }

  # Agora, definimos o "assunto" (subject) do nosso teste.
  # O shoulda-matchers vai usar ESTE molde, que é válido.
  subject { UserStock.new(user: user, stock: stock) }
  # --- FIM DO SETUP ---

  describe "associações" do
    it { should belong_to(:user) }
    it { should belong_to(:stock) }
  end

  # Agora este teste vai funcionar, pois ele usa o 'subject' que
  # nós definimos, que tem um 'user' e 'stock' válidos.
  it { should validate_uniqueness_of(:stock_id).scoped_to(:user_id) }
end