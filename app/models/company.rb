class Company < ActiveRecord::Base
  attr_accessible *attribute_names

  has_many :company_offices
  belongs_to :industry


  globalize :name, :description, :region, :position

  has_many :company_memberships
  has_many :users, through: :company_memberships#, class_name: User#, source: :user, source_type: User

  def company_role
    "#{company.position} компанії \"#{company.name}\""
  end

  def industry_name
    industry.name
  end

  def offices
    []
  end
end
