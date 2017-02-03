class CompanyOffice < ActiveRecord::Base
  attr_accessible *attribute_names

  include RecursiveParams

  belongs_to :company

  globalize :city, :address

  include HasPhones
end
