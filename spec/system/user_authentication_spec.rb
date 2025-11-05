# spec/system/user_authentication_spec.rb
require 'rails_helper'

RSpec.describe "Autenticação de Usuário", type: :system do
  
  # Cria um usuário de teste no banco ANTES do teste rodar
  let!(:user) { User.create!(email: 'test@example.com', password: 'password123') }

  context "com credenciais válidas" do
    it "permite que o usuário faça login e o redireciona para o dashboard (root)" do
      # 1. Visitar a página de login (usando nossa nova URL amigável)
      visit new_user_session_path # Helper do Devise (ele sabe que é /login)

      # 2. Preencher o formulário
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      # 3. Clicar no botão de "Log in"
      click_button "Log in"

      # 4. Verificar o resultado
      
      # Estamos na URL raiz (http://localhost:3000/)?
      expect(page).to have_current_path(root_path)
      
      # Vemos a mensagem de boas-vindas do Devise (prova que o login funcionou)
      #expect(page).to have_content("Signed in successfully.")
      expect(page).to have_content("Dashboard de Ações")
      
      # (Opcional, mas bom) Vemos algo que *prova* que é o dashboard?
      # Vamos adicionar um "marcador" na view
    end
  end
  
  context "com credenciais inválidas" do
    # Vamos deixar isso aqui para quando formos refatorar.
    # TDD é um passo de cada vez.
  end
end