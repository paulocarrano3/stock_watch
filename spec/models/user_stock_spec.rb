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

  describe "lógica de portfólio" do
    let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
    
    # O preço ATUAL da ação (do nosso banco) é $150
    let(:stock) { Stock.create!(ticker: 'TEST', name: 'Test Stock', last_price: 150.00) }

    # O usuário comprou 10 ações a um preço médio de $100
    let(:user_stock) do
      UserStock.create!(
        user: user,
        stock: stock,
        units: 10,
        average_price: 100.00
      )
    end

    it "calcula o valor total de custo" do
      # Custo = 10 * $100 = $1000
      expect(user_stock.total_cost).to eq(1000.00)
    end

    it "calcula o valor total de mercado atual" do
      # Valor Atual = 10 * $150 = $1500
      expect(user_stock.market_value).to eq(1500.00)
    end
    
    it "calcula o lucro/prejuízo (P/L) em valor" do
      # P/L = $1500 (atual) - $1000 (custo) = $500
      expect(user_stock.profit_loss_amount).to eq(500.00)
    end
    
    it "calcula o lucro/prejuízo (P/L) em percentual" do
      # P/L % = (Preço Atual - Preço Médio) / Preço Médio
      # (150 - 100) / 100 = 0.5 (ou 50%)
      expect(user_stock.profit_loss_percent).to eq(50.0)
    end
  end
end