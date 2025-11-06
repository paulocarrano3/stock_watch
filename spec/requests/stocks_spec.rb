require 'rails_helper'

RSpec.describe "Stocks", type: :request do
  describe "GET /search" do
    it "returns http success" do
      get "/stocks/search"
      expect(response).to have_http_status(:success)
    end
  end

end
