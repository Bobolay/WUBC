class Company < ActiveRecord::Base
  attr_accessible *attribute_names

  has_many :company_offices


  globalize :name, :description, :region, :position

  has_many :company_memberships
  has_many :members, through: :company_memberships, class_name: User
end
