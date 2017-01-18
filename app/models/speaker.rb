class Speaker < ActiveRecord::Base
  attr_accessible *attribute_names

  globalize :name, :description

  image :image, styles: { wide: "670x300#" }

  boolean_scope :published
  scope :sort_by_sorting_position, -> { order("sorting_position asc") }

  has_cache do
    pages :home
  end
end
