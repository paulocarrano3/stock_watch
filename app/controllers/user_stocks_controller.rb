class UserStocksController < ApplicationController
  before_action :authenticate_user!
  
  def create
    # 1. Pegar o ticker que o formulário escondeu
    ticker = params[:ticker]
    
    # 2. Procurar no NOSSO banco de dados se já temos essa Ação.
    #    Se não, crie uma nova.
    # (Este é o "Pulo do Gato" do projeto)
    stock = Stock.find_or_create_by(ticker: ticker) do |s|
      # Se for 'create_by' (novo), precisamos dos dados da API
      # Vamos re-buscar os dados (é mais seguro que confiar no form)
      service = StockQuoteService.new
      api_data = service.quote(ticker) # Chama a API de verdade
      
      # Preenche os dados do nosso modelo
      s.name = ticker # Finnhub não dá o nome no 'quote' (problema futuro)
      s.last_price = api_data[:price]
    end

    # 3. Criar o "Follow" (a associação)
    @user_stock = UserStock.new(user: current_user, stock: stock)

    # 4. Salvar e redirecionar
    if @user_stock.save
      # Se salvou, mande para o Dashboard com uma msg de sucesso
      flash[:notice] = "Ação #{stock.ticker} seguida com sucesso!"
      redirect_to root_path
    else
      # Se falhou (ex: já estava seguindo), volte para a busca com erro
      flash[:alert] = "Não foi possível seguir a ação."
      redirect_to stocks_search_path
    end
  end

  def destroy
    # O 'params[:id]' que o botão vai enviar será o ID da *Stock*,
    # não o ID do *UserStock* (vamos facilitar para a view).

    # 1. Encontre a Ação (Stock) que queremos parar de seguir
    stock = Stock.find(params[:id])

    # 2. Encontre o "Follow" (UserStock)
    #    BUSCANDO APENAS DENTRO DOS FOLLOWS DO USUÁRIO LOGADO (Segurança!)
    user_stock = current_user.user_stocks.find_by(stock_id: stock.id)

    # 3. Destrua o "Follow"
    if user_stock&.destroy # O '&.' (safe navigation) evita erro se 'user_stock' for nil
      flash[:notice] = "Ação #{stock.ticker} deixou de ser seguida."
    else
      flash[:alert] = "Não foi possível deixar de seguir a ação."
    end
    # 4. Volte para o Dashboard
    redirect_to root_path
  end
end