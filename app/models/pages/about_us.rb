class Pages::AboutUs < Cms::Page
  #has_html_block :content

  #alias :url :default_url
  def url(*args)
    "/about-us"
  end
end