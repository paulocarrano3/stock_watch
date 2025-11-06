class DashboardController < ApplicationController

  before_action :authenticate_user!

  def index
    # Peça ao 'current_user' para buscar todas as 'stocks' que ele segue.
    @followed_stocks = current_user.stocks
  end
end
