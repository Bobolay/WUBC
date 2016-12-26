class Company < ActiveRecord::Base
  attr_accessible *attribute_names

  include RecursiveParams

  has_many :company_offices
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

  attr_accessible :industry_name
end
