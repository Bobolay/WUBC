class RegistrationsController < Users::RegistrationsController
  skip_all_before_action_callbacks
  def create
    user = Member.create(sign_up_user_params)
    render json: {}
  end

  def sign_up_user_params
    params[:user].permit(:birth_date, :phone, :email, :password, :password_confirmation)
  end

  def sign_up_user_translation_params
    params[:user].permit(:first_name, :last_name, :middle_name)
  end
end