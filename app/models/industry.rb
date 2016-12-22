class Industry < ActiveRecord::Base
  globalize :name

  has_many :companies
  attr_accessible :companies, :company_ids
end
