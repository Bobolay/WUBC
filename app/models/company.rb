class Company < ActiveRecord::Base
  attr_accessible *attribute_names

  include RecursiveParams

  has_many :company_offices, autosave: true
  belongs_to :industry





  globalize :name, :description, :region, :position

  has_many :company_memberships
  has_many :users, through: :company_memberships#, class_name: User#, source: :user, source_type: User

  attr_accessible :industry, :company_offices, :company_memberships, :users

  def company_role
    "#{company.position} компанії \"#{company.name}\""
  end

  def industry_name
    return nil if !industry

    industry.name
  end

  def offices
    []
  end

  def industry_name=(company_industry_name)
    puts "industry_name= #{company_industry_name}"
    is_industry_id = company_industry_name == company_industry_name.to_i.to_s
    if !is_industry_id
      industry = Industry.all.joins(:translations).where(industry_translations: { name: company_industry_name }).first
      if !industry
        industry = Industry.new
        industry.translations << industry.translations.new(name: company_industry_name, locale: I18n.locale)
        industry.save
      end

      self.industry_id = industry.id
    else
      self.industry_id = company_industry_name
    end

    true
  end

  def set_offices(offices_params)
    params_companies_count = offices_params.count
    params_companies_max_index = params_companies_count - 1
    self.company_offices.each_with_index do |c, i|
      c.delete if i > params_companies_max_index
    end

    offices_params.each_with_index do |office_params, office_index|
      office_params = office_params[1] if office_params.is_a?(Array)
      office_index = office_index.to_i
      office = self.company_offices[office_index]
      office ||= self.company_offices.new
      puts "office_params: #{office_params.inspect}"
      office.update_params(office_params)
    end
  end

  attr_accessible :industry_name

  def social_links
    Hash[[:facebook, :google_plus].map{|k| [k, send("social_#{k}") ]  }.select{|item| item[1].present? }]
  end
end
