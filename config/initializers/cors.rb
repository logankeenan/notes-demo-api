# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.development?
      origins 'localhost:4000'
    else
      origins "notes-demo-spa.pages.dev" "notes-demo-cf-worker.logankeenan.workers.dev"
    end

    resource "*",
             headers: :any,
             expose: ["user_id"],
             methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
