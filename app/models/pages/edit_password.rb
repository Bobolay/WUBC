class Pages::EditPassword < Cms::Page
  def url(*args)
    "/password/edit"
  end

  def show_on_sitemap
    false
  end
end