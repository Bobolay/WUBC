class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
  #before_action :set_sign_in_page_metadata, only: :new

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
    referrer_url = request.referrer
    #referrer_uri = URI(referrer_url)
    #premium_location = str.start_with?("/members")

    referrer_url || "/"
  end
end
