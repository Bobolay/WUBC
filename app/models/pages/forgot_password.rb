class Pages::ForgotPassword < Cms::Page
  def url(*args)
    "/password/new"
  end
end