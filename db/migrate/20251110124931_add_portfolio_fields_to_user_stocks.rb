class AddPortfolioFieldsToUserStocks < ActiveRecord::Migration[8.0]
  def change
    add_column :user_stocks, :units, :decimal
    add_column :user_stocks, :average_price, :decimal
  end
end
