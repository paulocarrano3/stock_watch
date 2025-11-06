# Rails.application.routes.draw do

#   get "dashboard/index"
#   devise_for :users
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

#   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
#   # Can be used by load balancers and uptime monitors to verify that the app is live.
#   get "up" => "rails/health#show", as: :rails_health_check

#   # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
#   # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
#   # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

#   # Defines the root path route ("/")
#   # root "posts#index"
# end

Rails.application.routes.draw do
  # 1. Definimos a Rota Raiz (Instrução 2 do Devise)
  # Quando um usuário logado acessar a "homepage" (http://localhost:3000/),
  # ele será levado ao DashboardController, ação 'index'.
  root to: "dashboard#index"

  # 2. Rotas do Devise (com URLs amigáveis)
  # Isso faz o login ser /login, o logout /logout, etc.
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    sign_up: 'cadastro'
  }

  # 3. A rota do dashboard que o gerador criou (get 'dashboard/index')
  # é agora redundante, pois a 'root' aponta para ela.
  # Podemos deletar a linha 'get "dashboard/index"' se ela ainda existir.

  #get "stocks/search"
  # --- Nossas Novas Rotas ---
  # Remove a linha 'get "stocks/search"' que o gerador criou.
  # E adicione estas:
  
  # 1. A rota GET para a página
  get 'stocks/search', to: 'stocks#search', as: 'stocks_search'
  
  # 2. A rota POST que o formulário vai usar
  post 'stocks/search', to: 'stocks#search'

  resources :user_stocks, only: [:create]

  #get "user_stocks/create" adicionada automaticamente lá no topo
end