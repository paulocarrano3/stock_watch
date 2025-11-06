class StocksController < ApplicationController
  before_action :authenticate_user!

  def search
    #debugger
    # Se a requisição for um POST, significa que o form foi enviado
    if request.post? && params[:ticker].present?
      #debugger
      @ticker = params[:ticker].strip.upcase
      
      # 1. Chamar nosso "motor" (o serviço)
      service = StockQuoteService.new
      @stock_data = service.quote(@ticker) # Isso será 'mockado' no teste

      # 2. Lidar com falhas
      unless @stock_data
        @error = "Ticker '#{@ticker}' não encontrado ou API indisponível."
      end
    end
    
    # 3. Renderizar a view 'search.html.erb'
    # (O Rails faz isso automaticamente)
    # A view agora terá @stock_data ou @error e mostrará o resultado.
  end
end

