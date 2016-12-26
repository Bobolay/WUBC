class RegistrationsController < Users::RegistrationsController
  skip_all_before_action_callbacks
  def create
    user = Member.create(sign_up_user_params)
    user.update_params(params[:user])

    company = user.companies.create(company_params)
    company_industry_name = company_params[:industry]
    is_company_id = company_industry_name == company_industry_name.to_i.to_s

    if !is_company_id
      industry = Industry.new
      industry.translations << industry.translations.new(name: company_industry_name, locale: I18n.locale)
      industry.save
      company.industry_id = industry.id
    else
      company.industry_id = company_industry_name
    end




    company.translations << company.translations.new(company_translation_params)

    user.save

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
    company_params = company.permit(:industry, :company_site, :offices, :employees_count)

    company_params
  end

  def company_translation_params
    company = params[:company]
    translation_params = company.permit(:name, :description, :region, :position)

    translation_params
  end
end