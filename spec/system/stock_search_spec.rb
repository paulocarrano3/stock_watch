require 'rails_helper'

RSpec.describe "Busca de Ações", type: :system, js: true do
  # Cria um usuário e faz o login antes de cada teste
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  #before { sign_in user } # sign_in é um helper do Devise para testes
  before { login_as(user) }

  context "com um ticker válido" do

    # before do
    #   # --- O MOCK ---
    #   # "Ensina" o RSpec a interceptar qualquer chamada ao nosso serviço
    #   # e retornar um hash falso, mas bem-sucedido.
    #   # O teste NUNCA vai tocar na API da Finnhub.
    #   fake_data = { price: 123.45, percent_change: 2.5 }
      
    #   # allow_any_instance_of é poderoso. Ele intercepta qualquer 'new'
    #   allow_any_instance_of(StockQuoteService).to receive(:quote).and_return(fake_data)
    #   # .with("AAPL") removido
    #   # ---------------
    # end

    # it "mostra os resultados da busca na página" do
    #   # 1. Visitar a página de busca
    #   visit stocks_search_path

    #   # 2. Preencher o formulário
    #   #fill_in "ticker", with: "AAPL" # O 'name' do input será 'ticker'
    #   # (Vamos usar o texto da tag <label> para sermos explícitos)
    #   fill_in "Ticker da Ação", with: "AAPL"

    #   # 3. Clicar no botão
    #   click_button "Search"

    #   # 4. Verificar os resultados (da nossa 'fake_data')
    #   expect(page).to have_content("AAPL") # O ticker
    #   expect(page).to have_content("$123.45") # O preço formatado
    #   expect(page).to have_content("+2.5%") # A variação
    # end
    
    # SUBSTITUA O BLOCO 'BEFORE' ANTIGO POR ESTE:
    before do
      # --- O MOCK "BLINDADO" ---
      
      # 1. Crie um "dublê" (mock) para o nosso serviço
      fake_service = instance_double(StockQuoteService)
      
      # 2. Crie nossos dados falsos
      fake_data = { price: 123.45, percent_change: 2.5 }

      # 3. Ensine o *dublê* a se comportar:
      #    "Quando alguém chamar 'quote' em você com 'AAPL', 
      #     devolva os dados falsos."
      allow(fake_service).to receive(:quote).with("AAPL").and_return(fake_data)

      # 4. A MÁGICA: Intercepte a criação de *novos* serviços:
      #    "Quando o controller tentar rodar StockQuoteService.new, 
      #     NÃO crie um de verdade. Em vez disso, entregue o *dublê*
      #     que nós acabamos de criar."
      allow(StockQuoteService).to receive(:new).and_return(fake_service)
      # --------------------------
    end

    it "mostra os resultados da busca na página" do
      # ... (o resto do 'it' fica exatamente igual)
      visit stocks_search_path
      fill_in "Ticker da Ação", with: "AAPL"
      click_button "Search"
      # ...
    end
  end
  
  context "com um ticker inválido" do
    # (Podemos fazer depois, TDD é baby steps)
  end
end