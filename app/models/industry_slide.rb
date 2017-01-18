class IndustrySlide < ActiveRecord::Base
  attr_accessible *attribute_names

  globalize :name

  boolean_scope :published
  scope :sort_by_sorting_position, -> { order("sorting_position asc") }

  image :image, styles: { large: "2000x500#" }

  has_cache do
    pages :about_us
  end
end
