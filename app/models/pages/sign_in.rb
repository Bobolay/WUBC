class Pages::SignIn < Cms::Page
  def url(*args)
    "/login"
  end

  def show_on_sitemap
    false
  end
end