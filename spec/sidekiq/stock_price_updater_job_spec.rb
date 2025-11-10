require 'rails_helper'
require 'sidekiq/testing' # Ferramenta especial para testar o Sidekiq

RSpec.describe StockPriceUpdaterJob, type: :job do
  
  # Vamos criar uma ação "velha" no banco
  let!(:stock) { Stock.create!(ticker: "AAPL", name: "Apple", last_price: 100.00) }

  # Vamos criar o "dublê" do nosso serviço de API
  let(:fake_service) { instance_double(StockQuoteService) }
  let(:fake_api_data) { { price: 150.00, percent_change: 2.5 } } # O novo preço

  before do
    # Configura o "dublê" (mock)
    # 1. "Quando o robô tentar criar um StockQuoteService.new..."
    allow(StockQuoteService).to receive(:new).and_return(fake_service)
    
    # 2. "...ensine o dublê a responder"
    allow(fake_service).to receive(:quote).with("AAPL").and_return(fake_api_data)
  end

  it "atualiza o last_price de uma ação existente" do
    # Verifica se o preço "velho" está correto
    expect(stock.last_price).to eq(100.00)
    
    # Roda o robô (o 'perform')
    described_class.new.perform
    
    # O teste: O preço mudou?
    expect(stock.reload.last_price).to eq(150.00)
  end

  it "lida com falhas da API (retorno nil)" do
    # Novo setup: API falha
    allow(fake_service).to receive(:quote).with("AAPL").and_return(nil)
    
    # Roda o robô
    described_class.new.perform
    
    # O teste: O preço "velho" NÃO foi alterado?
    expect(stock.reload.last_price).to eq(100.00)
  end
end