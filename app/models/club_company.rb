class ClubCompany < ActiveRecord::Base
  attr_accessible *attribute_names

  globalize :name, :description

  image :image, styles: {home: "110x100#", medium: "180x120>"}

  boolean_scope :published
  boolean_scope :featured
  scope :sort_by_sorting_position, -> { order("sorting_position asc") }

  def formatted_company_site
    company_site.gsub(/\Ahttps?\:/, "").gsub(/\A\/\//, "")
  end

  has_cache do
    pages :home, :club_companies
  end
end
