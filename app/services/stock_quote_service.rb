class StockQuoteService
  BASE_URL = "https://finnhub.io/api/v1"

  def initialize
    @api_key = Rails.application.credentials.finnhub[:api_key]
    
    # Configura uma conexão Faraday persistente
    @connection = Faraday.new(url: BASE_URL) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
      faraday.params['token'] = @api_key # Passa o token em *todos* os requests
    end
  end

  def quote(ticker)
    response = @connection.get("quote", { symbol: ticker.upcase })

    return nil unless response.success?

    parse_response(response.body)
  
  # Resgata de erros (ex: timeout, API fora)
  rescue Faraday::Error => e
    Rails.logger.error "Erro ao buscar cotação da Finnhub: #{e.message}"
    nil
  end

  private

  def parse_response(response_body)
    data = JSON.parse(response_body)
    
    # 'c' = current price (preço atual)
    # 'dp' = percent change (variação percentual)
    {
      price: data['c'],
      percent_change: data['dp']
    }
  end
end