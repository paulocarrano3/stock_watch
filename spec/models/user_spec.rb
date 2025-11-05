require 'rails_helper'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  # Testes do shoulda-matchers
  describe "associações" do
    it { should have_many(:user_stocks) }
    it { should have_many(:stocks).through(:user_stocks) }
  end
end