class Pages::Cabinet < Cms::Page
  def url(*args)
    "/cabinet"
  end

  def show_on_sitemap
    false
  end
end