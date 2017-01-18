class Pages::Articles < Cms::Page
  #alias :url :default_url

  def url(*args)
    "/articles"
  end
end