Rails.application.routes.draw do
  root to: "pages#main"

  controller :pages do
    get "about_us", action: "about_us"
    get "events", action: "events"
    get "event_one", action: "event_one"
    get "news", action: "news"
    get "new_one", action: "new_one"
    # get "contact-us", action: "contact_us"
  end

  match "*url", to: "application#render_not_found", via: [:get, :post, :path, :put, :update, :delete]
end