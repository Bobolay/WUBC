class AliasController < ActionController::Base
  def root_without_locale
    redirect_to root_path(locale: I18n.locale)
  end
end