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
    render template: "errors/not_found.html.slim", status: 404, layout: "error", locals: { status: 404, title: "Сторінку не знайдено", description: "На жаль вказану сторінку не знайдено, будь ласка поверніться на головну сторінку сайту." }
  end

  def render_not_authorized
    render template: "errors/not_found.html.slim", status: 401, layout: "error", locals: { status: 401, title: "You don't have permissions", description: "На жаль ви не маєте доступу. Будь ласка поверніться на головну сторінку сайту." }
  end

  def default_url_options
    {}
  end

  def admin_panel?
    admin = params[:controller].to_s.starts_with?("rails_admin")

    return admin
  end

  def confirmed
    render "users/confirmations/show"
  end

  def render_locked(back_url, back_title, description)
    @white_bg = true
    render "_locked", locals: {back_url: back_url, back_title: back_title, description: description}
  end

  def render_locked_event
    render_locked(events_path, "До всіх подій", "Перегляд даної події доступний лише для учасників клубу WUBC")
  end

  def render_locked_article
    render_locked(articles_path, "До всіх статтей", "Перегляд даної статті доступний лише для учасників клубу WUBC")
  end

  def render_locked_member
    render_locked(members_path, "До всіх членів", "Перегляд профілю членів доступний лише для учасників клубу WUBC")
  end

  def render_locked_members
    render_locked(members_path, "На головну", "Перегляд членів клубу доступний лише для учасників клубу WUBC")
  end

  rescue_from CanCan::AccessDenied do |exception|
    #redirect_to main_app.root_path, :alert => exception.message
    render_not_authorized
  end
end
