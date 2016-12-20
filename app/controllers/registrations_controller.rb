class RegistrationsController < Users::RegistrationsController


  def create
    user = Member.create(sign_up_user_params)
  end

  def sign_up_user_params
    params[:user].permit(:birth_date, :phone, :email, :password, :password_confirmation)
  end

  def sign_up_user_translation_params
    params[:user].permit(:first_name, :last_name, :middle_name)
  end
end