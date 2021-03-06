class Company < ActiveRecord::Base
  attr_accessible *attribute_names

  include RecursiveParams

  has_many :company_offices, autosave: true
  accepts_nested_attributes_for :company_offices
  belongs_to :industry



  globalize :name, :description, :region, :position

  has_many :company_memberships
  has_many :users, through: :company_memberships#, class_name: User#, source: :user, source_type: User

  has_many :company_regions
  has_and_belongs_to_many :regions, through: :company_regions
  attr_accessible :regions, :region_ids

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

  def company_site
    s = self['company_site']
    s = s.gsub(/\A\s/, "")
    return nil if s.blank?

    s = "http://#{s}" if !s.start_with?("http:") && !s.start_with?("https:") && !s.start_with?("//")
    s
  end

  def company_info_attributes
    h = {industry: industry_name, description: description, company_site: company_site, regions: company_regions.map{|cr| cr.region.try(:name) }.select(&:present?).uniq.join(", "), employees_count: employees_count}
    h.keep_if{|k, v| v.present? }
  end

  def expandable_attributes
    [:description]
  end

  def formatted_position
    "#{position} компанії &laquo;#{name}&raquo;"
  end

  def set_regions(values)
    company_regions.delete_all
    if values.blank?
      return
    end
    values = values.uniq


    values.each do |region_name|
      found_region = Region.find(region_name) rescue nil
      is_region_id = region_name == region_name.to_i.to_s
      if !is_region_id || !found_region
        region = Region.all.joins(:translations).where(region_translations: { name: region_name }).first
        if !region
          region = Region.new
          region.translations << region.translations.new(name: region_name, locale: I18n.locale)
          region.save
        end

        self.regions << region
      else
        self.regions << found_region
      end
    end

    true
  end
end
