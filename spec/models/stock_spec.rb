require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe "associações" do
    it { should have_many(:user_stocks) }
    it { should have_many(:users).through(:user_stocks) }
  end

  # Também queremos validar nossos dados
  describe "validações" do
    it { should validate_presence_of(:ticker) }
    it { should validate_presence_of(:name) }
  end
end