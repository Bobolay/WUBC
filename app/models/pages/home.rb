class Pages::Home < Cms::Page
  def url(locale = I18n.locale)
    "/"
  end

  has_images :slider_images, styles: {large: "2048x600#", thumb: "200x60#"}, class_name: "HomeSlide"
end