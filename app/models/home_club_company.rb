class HomeClubCompany < ActiveRecord::Base
  attr_accessible *attribute_names

  globalize :name, :description

  image :image, styles: {home: "110x100#"}

  boolean_scope :published
  scope :sort_by_sorting_position, -> { order("sorting_position asc") }
end
