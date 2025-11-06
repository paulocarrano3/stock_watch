require 'rails_helper'

RSpec.describe StockQuoteService do
  
  # Vamos usar VCR ou um mock simples.
  # Por agora, vamos focar em um teste de "fumaça" que usa o mock do RSpec.

  describe "#quote" do
    it "retorna dados formatados para um ticker válido" do
      # 1. Setup (O Mock)
      # Estamos 'ensinando' o RSpec a interceptar uma chamada de API.
      # Isso é complexo, então vamos fazer de um jeito mais simples...
      
      # Vamos mudar a abordagem para TDD "light":
      # Vamos testar se nosso objeto *tenta* chamar o Faraday.
      
      # Setup: Crie um "dublê" (mock) para o Faraday
      fake_connection = instance_double(Faraday::Connection)
      fake_response = instance_double(Faraday::Response, body: '{"c": 250.5, "dp": 1.5, "h": 255, "l": 249, "o": 251, "pc": 247, "t": 1678886400}', success?: true)
      
      # Expectativas (O que esperamos que aconteça)
      # Esperamos que o Faraday.new seja chamado com a URL da Finnhub
      expect(Faraday).to receive(:new).with(url: "https://finnhub.io/api/v1").and_return(fake_connection)
      
      # Esperamos que nosso 'dublê' receba um 'get'
      expect(fake_connection).to receive(:get).with("quote", anything).and_return(fake_response)

      # 2. Execução (Chamar nosso serviço)
      service = StockQuoteService.new
      result = service.quote("AAPL") # Ticker de teste

      # 3. Verificação (O que nosso serviço 'traduziu')
      expect(result).to be_a(Hash)
      expect(result[:price]).to eq(250.5)
      expect(result[:percent_change]).to eq(1.5)
    end

    it "retorna nil se a API falhar" do
      # Setup de falha
      fake_connection = instance_double(Faraday::Connection)
      fake_response = instance_double(Faraday::Response, success?: false)
      
      allow(Faraday).to receive(:new).and_return(fake_connection)
      allow(fake_connection).to receive(:get).and_return(fake_response)
      
      # Execução
      service = StockQuoteService.new
      result = service.quote("FAKETICKER")
      
      # Verificação
      expect(result).to be_nil
    end
  end
end