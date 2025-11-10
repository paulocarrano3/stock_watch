class StockPriceUpdaterJob
  include Sidekiq::Job # <-- Diz ao Sidekiq que este é um "manual"
  
  # Este é o método que o Sidekiq vai chamar
  def perform
    puts "🤖 [Sidekiq] Iniciando a atualização de preços..."
    
    service = StockQuoteService.new
    
    # 1. Busca TODAS as ações que *alguém* segue no nosso banco
    Stock.find_each do |stock|
      
      # 2. Liga para a API (no teste, isso é o "dublê")
      api_data = service.quote(stock.ticker)
      
      # 3. Se a API respondeu...
      if api_data && api_data[:price]
        # ...atualize o preço "velho" com o novo
        stock.update(last_price: api_data[:price])
        puts "  -> #{stock.ticker} atualizado para #{api_data[:price]}"
      else
        puts "  -> Falha ao buscar #{stock.ticker}"
      end
    end
    
    puts "🤖 [Sidekiq] Atualização de preços concluída."
  end
end