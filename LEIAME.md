
-----
[Versão em inglês](README.md)

# StockWatch 📈

Um rastreador de portfólio de ações construído com Ruby on Rails, Sidekiq e TDD (Test-Driven Development).

Este é um projeto que simula uma aplicação web full-stack do mundo real. O objetivo principal era demonstrar as melhores práticas de engenharia de software, incluindo TDD com RSpec, uso de Service Objects para APIs externas e a implementação de Background Jobs para tarefas assíncronas (como a atualização de preços).

-----

## ✨ Funcionalidades Principais (Features)

  * **Autenticação de Usuário:** Cadastro e login de usuários usando **Devise**.
  * **Pesquisa de Ações:** Consumo de uma API externa (Finnhub) para buscar cotações de ações em tempo real.
  * **Seguir Ações (Follow/Unfollow):** Usuários podem adicionar e remover ações de seu dashboard pessoal.
  * **Gerenciamento de Portfólio:** Usuários podem editar suas posições para cada ação.
  * **Cálculo de P/L:** O dashboard exibe o Lucro/Prejuízo de cada posição, calculado com base no preço médio e no preço atual.
  * **Atualização Automática de Preços:** Um **Sidekiq Worker** roda em segundo plano, agendado por um **Cron Job**, para atualizar os preços de todas as ações no banco de dados a cada 10 minutos, garantindo que os dados do dashboard estejam sempre recentes.
  * **Painel de Jobs:** O dashboard do Sidekiq está montado em `/sidekiq` para monitorar os background jobs.

-----

## 🛠️ Tech Stack (Tecnologias Usadas)

  * **Backend:** Ruby on Rails 8
  * **Banco de Dados:** PostgreSQL
  * **Testes (TDD):** RSpec, Shoulda-Matchers, Capybara (System Specs)
  * **Autenticação:** Devise
  * **Background Jobs:** Sidekiq
  * **Agendamento de Jobs:** Sidekiq-Cron
  * **Dependência do Sidekiq:** Redis
  * **API Externa:** Finnhub.io
  * **Cliente HTTP:** Faraday
  * **Front-end:** Tailwind CSS (via `tailwindcss-rails`)
  * **Servidor de Dev:** `bin/dev` (Procfile)

-----

## 🚀 Como Rodar Localmente (Getting Started)

Para clonar e rodar esta aplicação localmente, você precisará ter Ruby, Rails, PostgreSQL e Redis instalados.

1.  **Clone o repositório:**

    ```bash
    git clone https://github.com/seu-usuario/stock_watch.git
    cd stock_watch
    ```

2.  **Instale as dependências:**

    ```bash
    bundle install
    ```

3.  **Instale as dependências de Background:**
    *O Sidekiq precisa que o Redis-server esteja rodando.*

    ```bash
    # No Ubuntu/Debian
    sudo apt install redis-server
    # No macOS (usando Homebrew)
    # brew install redis
    ```

4.  **Configure o Banco de Dados:**

    ```bash
    rails db:create
    rails db:migrate
    ```

5.  **Adicione suas Chaves de API (Secrets):**
    *Este projeto usa a API da Finnhub.*

      * Vá em [finnhub.io](https://finnhub.io/) e crie uma conta gratuita para obter sua API Key.
      * Rode o editor de credenciais do Rails:
        ```bash
        EDITOR="code --wait" rails credentials:edit
        ```
      * Adicione sua chave no formato YAML:
        ```yaml
        finnhub:
          api_key: "sua_chave_da_finnhub_aqui"
        ```
      * Salve e feche o editor.

6.  **Inicie o servidor:**
    *O `bin/dev` iniciará o Rails, o Tailwind e o Sidekiq de uma só vez.*

    ```bash
    bin/dev
    ```

7.  **Acesse o app:**

      * **Aplicação:** `http://localhost:3000`
      * **Dashboard do Sidekiq:** `http://localhost:3000/sidekiq`

-----

## 🧪 Rodando os Testes

Este projeto foi construído com TDD. Para rodar a suíte de testes completa:

```bash
# Preparar o banco de dados de teste
rails db:test:prepare

# Rodar o RSpec
rspec
```

-----