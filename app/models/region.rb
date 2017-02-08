class Region < ActiveRecord::Base
  attr_accessible *attribute_names
  globalize :name

  has_and_belongs_to_many :companies
  attr_accessible :companies, :company_ids
end
