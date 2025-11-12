
-----
[Portuguese version](LEIAME.md)

# StockWatch 📈

A stock portfolio tracker built with Ruby on Rails, Sidekiq, and TDD (Test-Driven Development).

This is a project simulating a real-world, full-stack web application. The primary goal was to demonstrate software engineering best practices, including TDD with RSpec, the use of Service Objects for external APIs, and implementing Background Jobs for asynchronous tasks (like updating stock prices).

-----

## ✨ Core Features

  * **User Authentication:** User sign-up and login using **Devise**.
  * **Stock Search:** Consumes an external API (Finnhub) to fetch real-time stock quotes.
  * **Stock Tracking (Follow/Unfollow):** Users can add and remove stocks from their personal dashboard.
  * **Portfolio Management:** Users can edit their position for each tracked stock.
  * **P/L Calculation:** The dashboard displays the Profit/Loss for each position, calculated against the current market price.
  * **Automatic Price Updates:** A **Sidekiq Worker** runs in the background, scheduled by a **Cron Job**, to refresh all stock prices in the database every 10 minutes. This ensures the dashboard data stays current.
  * **Job Dashboard:** The Sidekiq UI is mounted at `/sidekiq` to monitor background jobs.

-----

## 🛠️ Tech Stack

  * **Backend:** Ruby on Rails 8
  * **Database:** PostgreSQL
  * **Testing (TDD):** RSpec, Shoulda-Matchers, Capybara (System Specs)
  * **Authentication:** Devise
  * **Background Jobs:** Sidekiq
  * **Job Scheduling:** Sidekiq-Cron
  * **Sidekiq Dependency:** Redis
  * **External API:** Finnhub.io
  * **HTTP Client:** Faraday
  * **Front-end:** Tailwind CSS (via `tailwindcss-rails`)
  * **Dev Server:** `bin/dev` (Procfile)

-----

## 🚀 Getting Started (Local Setup)

To clone and run this application locally, you will need Ruby, Rails, PostgreSQL, and Redis installed.

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/your-username/stock_watch.git
    cd stock_watch
    ```

2.  **Install dependencies:**

    ```bash
    bundle install
    ```

3.  **Install background job dependencies:**
    *Sidekiq requires a running Redis server.*

    ```bash
    # On Ubuntu/Debian
    sudo apt install redis-server
    # On macOS (using Homebrew)
    # brew install redis
    ```

4.  **Set up the database:**

    ```bash
    rails db:create
    rails db:migrate
    ```

5.  **Add your API Keys (Secrets):**
    *This project uses the Finnhub API.*

      * Go to [finnhub.io](https://finnhub.io/) and create a free account to get your API Key.
      * Run the Rails credentials editor:
        ```bash
        EDITOR="code --wait" rails credentials:edit
        ```
      * Add your key in the YAML format:
        ```yaml
        finnhub:
          api_key: "your_finnhub_api_key_here"
        ```
      * Save and close the editor.

6.  **Start the server:**
    *The `bin/dev` command will start the Rails server, Tailwind, and Sidekiq all at once.*

    ```bash
    bin/dev
    ```

7.  **Access the app:**

      * **Application:** `http://localhost:3000`
      * **Sidekiq Dashboard:** `http://localhost:3000/sidekiq`

-----

## 🧪 Running the Tests

This project was built using TDD. To run the full test suite:

```bash
# Prepare the test database
rails db:test:prepare

# Run RSpec
rspec
```

-----