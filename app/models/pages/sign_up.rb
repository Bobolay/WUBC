class Pages::SignUp < Cms::Page
  def url(*args)
    "/sign_up"
  end

  def show_on_sitemap
    false
  end
end