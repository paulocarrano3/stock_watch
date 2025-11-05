require 'rails_helper'

RSpec.describe UserStock, type: :model do
  describe "associações" do
    it { should belong_to(:user) }
    it { should belong_to(:stock) }
  end
end