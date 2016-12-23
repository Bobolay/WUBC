class Speaker < ActiveRecord::Base
  attr_accessible *attribute_names

  globalize :name, :description

  image :image, styles: { wide: "670x300#" }
end
