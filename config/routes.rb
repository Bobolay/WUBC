Rails.application.routes.draw do
  get "images_test", to: "pages#images_test"

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

  #patch "login", to: "users/sessions#create", as: "sign_in_user_via_patch"
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Ckeditor::Engine => '/ckeditor'
  get "check_email", to: "registrations#check_email", as: :check_email
  post "sign_up", to: "registrations#create", as: "sign_up"
  #post "/password/edit", to: "passwords#update", as: "custom_edit_password"


  devise_for :users, path: "", module: "users", path_names: {
      sign_in: "login",
      sign_out: 'logout',
      edit: 'profile',
      #sign_up: "sign_up"

      #user_registration
  }, controllers: { registrations: "registrations", sessions: "users/sessions", passwords: "users/passwords" }


  devise_scope :user do
    match "login", to: "users/sessions#create", via: [:post, :patch], as: "sign_in_user_via_patch"
    post "/password/edit", to: "passwords#update", as: "edit_password_via_post"
  end



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


  match "*url", to: "application#render_not_found", via: [:get, :post, :patch, :put, :update, :delete]
end