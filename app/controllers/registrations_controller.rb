class RegistrationsController < Users::RegistrationsController
  skip_all_before_action_callbacks

  before_action :set_sign_up_page_metadata, only: :new
  caches_page :new

  def create
    user = Member.create(sign_up_user_params)
    user.update_params(params[:user])
    user.save

    company = user.companies.create(company_params)
    company.update_params(params[:company])
    if params[:company] && params[:company][:offices]

      company.set_offices(params[:company][:offices])
    end
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

  def check_email
    #sleep([10].sample)
    params_email = params[:email]
    return render status: 400 if params_email.blank?
    exists = User.where(email: params_email).count > 0
    render json: { email: params_email, exists: exists }, status: 200
  end

  def current_user_short_info
    if !current_user
      return render json: {}, status: 401
    end

    u = current_user

    h = { email: u.email, first_and_last_name: u.full_name_or_email(false), small_avatar: u.avatar.exists?(:small) ? u.avatar.url(:small) : nil }

    h[:default_small_avatar] = controller_asset_path("photo/user_no_avatar-72.png")

    render json: h
  end

  protected
  def set_sign_up_page_metadata
    set_page_metadata(:sign_up)
  end
end