class Testimonial < ActiveRecord::Base
  attr_accessible *attribute_names
  globalize :name, :position, :description

  image :image, styles: {large: "1000x600#"}

  boolean_scope :published
  scope :sort_by_sorting_position, -> { order("sorting_position asc") }
end