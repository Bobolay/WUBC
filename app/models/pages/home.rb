class Pages::Home < Cms::Page
  def url(locale = I18n.locale)
    "/"
  end

  # {large: "2048x676#", thumb: "200x60#"}
  has_images :slider_images, styles: {large: "1920x1000#", thumb: "200x60#"}, processors: [:thumbnail, :tinify], class_name: "HomeSlide"
end