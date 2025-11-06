require 'rails_helper'

RSpec.describe "Conteúdo do Dashboard", type: :system, js: true do
  
  let!(:user) { User.create!(email: 'test@example.com', password: 'password123') }

  # Vamos criar dados 'falsos' no banco ANTES do teste
  let!(:stock1) { Stock.create!(ticker: "AAPL", name: "Apple", last_price: 150.00) }
  let!(:stock2) { Stock.create!(ticker: "MSFT", name: "Microsoft", last_price: 300.00) }

  context "quando o usuário NÃO segue nenhuma ação" do
    it "mostra uma mensagem de boas-vindas" do
      login_as(user)
      visit root_path

      expect(page).to have_content("Você ainda não segue nenhuma ação.")
      expect(page).to_not have_content("AAPL")
    end
  end

  context "quando o usuário SEGUE ações" do
    before do
      # Criamos as "pontes" (Follows)
      UserStock.create!(user: user, stock: stock1)
      UserStock.create!(user: user, stock: stock2)
    end

    it "lista as ações seguidas no dashboard" do
      login_as(user)
      visit root_path

      # Verifica se a página agora tem os dados do banco
      expect(page).to have_content("AAPL")
      expect(page).to have_content("$150.00") # O preço 'antigo' do banco
      
      expect(page).to have_content("MSFT")
      expect(page).to have_content("$300.00")
      
      expect(page).to_not have_content("Você ainda não segue nenhuma ação.")
    end
  end
end