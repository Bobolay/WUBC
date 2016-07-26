Rails.application.routes.draw do
  root to: "pages#main"

  controller :pages do
    get "events", action: "events"
    get "event_one", action: "event_one"
    get "news", action: "news"
    get "new_one", action: "new_one"
    # get "contact-us", action: "contact_us"
  end

  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # mount Ckeditor::Engine => '/ckeditor'
  #devise_for :users


  match "*url", to: "application#render_not_found", via: [:get, :post, :path, :put, :update, :delete]
end