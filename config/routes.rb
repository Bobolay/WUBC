Rails.application.routes.draw do
  root as: "root_without_locale", to: "alias#root_without_locale"
  get "admin(/*admin_path)", to: redirect{|params| "/#{ I18n.default_locale}/admin/#{params[:admin_path]}"}

  scope "(:locale)", locale: /#{I18n.available_locales.map(&:to_s).join("|")}/ do
    scope "cabinet", controller: "cabinet" do
      root action: "index", as: :cabinet
      get "events", action: "events", as: "cabinet_events"
      get "profile", action: "profile", as: "cabinet_profile"
      get "companies", action: "companies", as: "cabinet_companies"

    end

    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    mount Ckeditor::Engine => '/ckeditor'
    devise_for :users, path: "", path_names: {
        sign_in: "login",
        sign_out: 'logout',
        registration: "register",
        edit: 'profile'
    }
    root to: "pages#index"

    resources :events, only: [:index, :show]
    resources :articles, only: [:index, :show]
    resources :members, only: [:index, :show]

    controller :pages do
      get "about-club", action: "about_us", as: :about_us
      get "partners", action: "partners", as: :partners
      get "contacts", action: "contacts", as: :contacts
    end
  end

  match "*url", to: "application#render_not_found", via: [:get, :post, :path, :put, :update, :delete]
end