class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
  before_action :set_sign_in_page_metadata, only: :new
  caches_page :new

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end

  def set_sign_in_page_metadata
    set_page_metadata(:sign_in)
  end

  def after_sign_in_path_for(resource_or_scope)
    default_url = "/"
    referrer_url = request.referrer
    referrer_uri = URI(referrer_url)
    referrer_path = referrer_uri.path
    path_parts = referrer_path.split("/").select(&:present?)

    if path_parts[0] == "login"
      return super(resource_or_scope)
    end

    if path_parts[0] == "sign_up"
      return default_url
    end

    referrer_url || default_url
  end

  def after_sign_out_path_for(resource_or_scope)
    options = {
        from_resourse_to_parent: true
    }
    referrer_url = request.referrer
    default_url = "/"
    puts "after_sign_out_path_for: 0"
    if referrer_url.blank?
      return default_url
    end

    puts "after_sign_out_path_for: 1"

    referrer_uri = URI(referrer_url)
    if referrer_uri.host != ENV["#{Rails.env}.host"]
      return referrer_url
    end

    referrer_path = referrer_uri.path
    path_parts = referrer_path.split("/").select(&:present?)

    puts "after_sign_out_path_for: 2"

    if path_parts[0] == "members"
      return default_url
    end

    puts "after_sign_out_path_for: 3"

    if path_parts[0] == "events" && path_parts[1]
      event = Event.get(path_parts[1])
      parent_page_url = "/events"
      return event && event.public? ? referrer_url : parent_page_url
    end

    puts "after_sign_out_path_for: 4"

    if path_parts[0] == "articles" && path_parts[1]
      article = Article.get(path_parts[1])
      parent_page_url = "/articles"
      return article && article.public? ? referrer_url : parent_page_url
    end

    puts "after_sign_out_path_for: 5"

    if !path_parts[0] || path_parts[0].in?(%w(cabinet sign_up login admin password))
      return default_url
    end

    puts "after_sign_out_path_for: 6"

    referrer_url
  end
end
