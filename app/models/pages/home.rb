class Pages::Home < Cms::Page
  def self.full_screen_image_styles
    { thumb: '150x150' }
  end

  has_image :welcome_image, styles: full_screen_image_styles
  has_image :about_image, styles: full_screen_image_styles
  has_image :collection_image, styles: full_screen_image_styles
  has_image :help_image, styles: full_screen_image_styles
  has_image :publications_image, styles: full_screen_image_styles
  has_image :contact_image, styles: full_screen_image_styles


end