class Pages::ForgotPassword < Cms::Page
  def url(*args)
    "/password/new"
  end

  def show_on_sitemap
    false
  end
end