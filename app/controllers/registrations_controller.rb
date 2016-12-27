class RegistrationsController < Users::RegistrationsController
  skip_all_before_action_callbacks
  def create
    user = Member.create(sign_up_user_params)
    user.update_params(params[:user])
    user.save

    company = user.companies.create(company_params)
    company.update_params(params[:company])
    company.save

    # offices, industry

    render json: {}
  end

  def sign_up_user_params
    params[:user].permit(:birth_date, :phone, :email, :password, :password_confirmation)
  end

  def sign_up_user_translation_params
    translation_params = params[:user].permit(:first_name, :last_name, :middle_name)
    translation_params[:locale] ||= I18n.locale

    translation_params
  end

  def company_params
    company = params[:company]
    company[:industry_name] ||= company.delete(:industry)
    company_params = company.permit(:industry_name, :company_site, :offices, :employees_count)

    company_params
  end

  def company_translation_params
    company = params[:company]
    translation_params = company.permit(:name, :description, :region, :position)

    translation_params
  end
end