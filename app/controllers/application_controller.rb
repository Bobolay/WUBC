class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  include ActionView::Helpers::OutputSafetyHelper
  include Cms::Helpers::ImageHelper
  include ActionView::Helpers::AssetUrlHelper
  include Cms::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include Cms::Helpers::PagesHelper
  include Cms::Helpers::MetaDataHelper
  include Cms::Helpers::NavigationHelper
  include Cms::Helpers::ActionView::UrlHelper
  #include Cms::Helpers::TranslationHelper
  include ApplicationHelper

  #include CanCan::ControllerAdditions

  reload_text_translations

  reload_rails_admin_config

  before_action :set_locale, unless: :admin_panel?

  def set_locale
    I18n.locale = I18n.default_locale
  end

  def render_not_found
    render template: "errors/not_found.html.slim", status: 404, layout: false, locals: { status: 404, title: "Page not found" }
  end

  def render_not_authorized
    render template: "errors/not_found.html.slim", status: 401, layout: false, locals: { status: 401, title: "You don't have permissions" }
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def admin_panel?
    admin = params[:controller].to_s.starts_with?("rails_admin")

    return admin
  end

  rescue_from CanCan::AccessDenied do |exception|
    #redirect_to main_app.root_path, :alert => exception.message
    render_not_authorized
  end
end
