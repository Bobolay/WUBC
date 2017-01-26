class Users::PasswordsController < Devise::PasswordsController
  before_action :set_forgot_password_page_metadata, only: :new
  before_action :set_edit_password_metadata, only: :edit
  caches_page :new
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  protected

  def set_forgot_password_page_metadata
    set_page_metadata(:forgot_password)
  end

  def set_edit_password_metadata
    set_page_metadata(:edit_password)
  end

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
