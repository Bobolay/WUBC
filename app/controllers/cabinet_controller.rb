class CabinetController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cabinet_page_metadata

  def index
    #redirect_to cabinet_events_path
    @events = Event.subscribed_by_user(current_user).order("date desc")

    render "layouts/cabinet", layout: false
  end

  def events
  end

  def profile
    u = current_user

    #return render inline: "OK"
    if request.post?
      #params_user = user_params
      personal_helpers_params = params[:user][:personal_helpers]
      puts "controller: params.user.personal_helpers: #{personal_helpers_params.inspect}"
      local_user_params = params[:user].keep_if{|k, v| k.to_s != "email" && k.to_s != "personal_helpers"  }
      u.set_personal_helpers(personal_helpers_params)
      u.update_params(local_user_params)

      return render json: {status: "OK"}, status: 200
    end

    render status: 403
  end

  def companies
    params_companies_count = params[:companies].count
    params_companies_max_index = params_companies_count - 1
    current_user.companies.each_with_index do |c, i|
      c.delete if i > params_companies_max_index
    end

    params[:companies].each do |company_index, company_params|
      company_index = company_index.to_i
      puts "company_index: #{company_index}"
      company_params[:industry_name] ||= company_params.delete(:industry)
      regions = company_params.delete(:regions)
      company = current_user.companies[company_index]
      if !company
        company = Company.create
        CompanyMembership.create(company_id: company.id, user_id: current_user.id)
      end

      puts "controller: offices: #{company_params[:offices].inspect}"
      company.set_regions(regions)
      company.set_offices(company_params[:offices])

      company.update_params(company_params)
    end


    render json: {}
  end



  def user_params
    params[:user].permit(:phone, :birth_date)
  end

  def user_translation_params
    params[:user].permit(:first_name, :last_name, :middle_name)
  end

  def set_avatar
    u = current_user
    avatar_params = params.permit(:avatar)
    u.update(avatar_params)

    render json: { cabinet_avatar_url: u.avatar.url(:cabinet), small_avatar_url: u.avatar.url(:small) }
  end


  protected
  def set_cabinet_page_metadata
    set_page_metadata(:cabinet)
  end

end