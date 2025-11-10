# spec/system/edit_portfolio_spec.rb
require 'rails_helper'

RSpec.describe "Edição de Portfólio", type: :system, js: true do
  
  let!(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  
  # Preço ATUAL da ação no banco
  let!(:stock) { Stock.create!(ticker: "AAPL", name: "Apple", last_price: 150.00) }
  
  # O "Follow" inicial, com valores zerados (como é hoje)
  let!(:user_stock) { UserStock.create!(user: user, stock: stock, units: 0, average_price: 0) }

  it "permite ao usuário adicionar unidades e preço médio" do
    login_as(user)
    visit root_path
    
    # --- Parte 1: O Link "Detalhes" (VERMELHO 🔴) ---
    # 1. Procura o link "Detalhes" na linha da "AAPL"
    find("tr", text: "AAPL").click_link("Detalhes")
    
    # 2. Espera ir para a página "Show" do UserStock
    expect(page).to have_current_path(user_stock_path(user_stock))
    expect(page).to have_content("Detalhes de AAPL")
    # Mostra o P/L (que deve ser $0, pois não temos ações)
    expect(page).to have_content("Lucro/Prejuízo: $0.00")

    # --- Parte 2: O Link "Editar" (VERMELHO 🔴) ---
    # 3. Clica em "Editar"
    click_link "Editar Portfólio"
    
    # 4. Espera ir para a página "Edit"
    expect(page).to have_current_path(edit_user_stock_path(user_stock))

    # --- Parte 3: O Formulário (VERMELHO 🔴) ---
    # 5. Preenche o formulário
    fill_in "Unidades", with: "10"
    fill_in "Preço Médio", with: "100"
    click_button "Salvar Alterações" # Ou "Update User stock"

    # --- Parte 4: O Resultado (VERDE 🟢) ---
    # 6. Espera ser redirecionado de volta para a pág "Show"
    expect(page).to have_current_path(user_stock_path(user_stock))
    
    # 7. O P/L agora deve estar correto!
    # Custo: 10 * $100 = $1000
    # Valor: 10 * $150 (do 'let!') = $1500
    # P/L: $500
    expect(page).to have_content("Lucro/Prejuízo: $500.00")
    expect(page).to have_content("Posição atualizada com sucesso!")
  end
end