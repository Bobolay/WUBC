class CompanyOffice < ActiveRecord::Base
  attr_accessible *attribute_names
  belongs_to :company

  globalize :city, :address
end
