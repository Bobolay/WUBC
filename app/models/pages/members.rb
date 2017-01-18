class Pages::Members < Cms::Page
  #alias :url :default_url
  def url(*args)
    "/members"
  end
end