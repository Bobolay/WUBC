class Industry < ActiveRecord::Base
  attr_accessible *attribute_names
  globalize :name

  has_many :companies
  attr_accessible :companies, :company_ids
end
