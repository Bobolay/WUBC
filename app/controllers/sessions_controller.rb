class SessionsController < Users::SessionsController
  before_action :set_sign_in_page_metadata, only: :new

  skip_all_before_action_callbacks


  protected
  def set_sign_up_page_metadata
    set_page_metadata(:sign_in)
  end
end