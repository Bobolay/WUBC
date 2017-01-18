Rails.application.routes.draw do

  get "current_user", to: "registrations#current_user_short_info"

  resources :locales do
    resources :translations, constraints: { :id => /[^\/]+/ }
  end

  get "confirmed", to: "application#confirmed"

  scope "cabinet", controller: "cabinet" do
    root action: "index", as: :cabinet
    post "avatar", action: "set_avatar"

    get "events", action: "events", as: "cabinet_events"
    match "profile", action: "profile", as: "cabinet_profile", via: [:get, :post]
    match "companies", action: "companies", as: "cabinet_companies", via: [:get, :post]

  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Ckeditor::Engine => '/ckeditor'
  get "check_email", to: "registrations#check_email", as: :check_email
  post "sign_up", to: "registrations#create", as: "sign_up"
  devise_for :users, path: "", module: "users", path_names: {
      sign_in: "login",
      sign_out: 'logout',
      edit: 'profile',
      #sign_up: "sign_up"

      #user_registration
  }, controllers: { registrations: "registrations" }

  root to: "pages#index"

  scope :events, controller: "events" do
    root to: "events#index", as: :events, action: :index
    get ":id", as: :event, action: :show
    get ":id/subscribe", as: :subscribe_on_event, action: :subscribe
    get ":id/unsubscribe", as: :unsubscribe_from_event, action: :unsubscribe
  end


  resources :articles, only: [:index, :show]
  resources :members, only: [:index, :show]

  controller :pages do
    get "about-us", action: "about_us", as: :about_us
    get "partners", action: "partners", as: :partners
    get "contacts", action: "contacts", as: :contacts
  end


  match "*url", to: "application#render_not_found", via: [:get, :post, :path, :put, :update, :delete]
end