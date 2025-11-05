# spec/system/dashboard_access_spec.rb
require 'rails_helper'

RSpec.describe "Acesso ao Dashboard", type: :system do
  
  context "quando o usuário não está logado" do
    it "redireciona para a página de login" do
      # 1. Tenta acessar a página protegida
      visit root_path #antes era dashboard_index_path
      
      # 2. Espera ser redirecionado para a tela de login
      expect(page).to have_current_path(new_user_session_path)
      
      # 3. (Opcional) Verifica a mensagem de "bronca" do Devise
      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end
  
  context "quando o usuário está logado" do
    # Vamos deixar isso aqui para o futuro, por enquanto não precisamos.
    # it "mostra a página do dashboard"
  end
  
end