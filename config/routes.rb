Rails.application.routes.draw do

  root as: "root_without_locale", to: "alias#root_without_locale"
  get "admin(/*admin_path)", to: redirect{|params| "/#{ I18n.default_locale}/admin/#{params[:admin_path]}"}

  resources :locales do
    resources :translations, constraints: { :id => /[^\/]+/ }
  end

  scope "(:locale)", locale: /#{I18n.available_locales.map(&:to_s).join("|")}/ do
    scope "cabinet", controller: "cabinet" do
      root action: "index", as: :cabinet
      get "events", action: "events", as: "cabinet_events"
      get "profile", action: "profile", as: "cabinet_profile"
      get "companies", action: "companies", as: "cabinet_companies"

    end

    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    mount Ckeditor::Engine => '/ckeditor'
    post "sign_up", to: "users/registrations#create", as: "sign_up"
    devise_for :users, path: "", module: "users", path_names: {
        sign_in: "login",
        sign_out: 'logout',
        edit: 'profile',
        #sign_up: "sign_up"

        #user_registration
    }
    
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
      get "about_us", action: "about_us", as: :about_us
      get "partners", action: "partners", as: :partners
      get "contacts", action: "contacts", as: :contacts
    end
  end

  match "*url", to: "application#render_not_found", via: [:get, :post, :path, :put, :update, :delete]
end