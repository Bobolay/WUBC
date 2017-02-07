class CompanyRegion < ActiveRecord::Base
  self.table_name = :companies_regions
  attr_accessible *attribute_names

  belongs_to :company
  belongs_to :region

  default_scope do
    order("id asc")
  end
end