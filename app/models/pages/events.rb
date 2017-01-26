class Pages::Events < Cms::Page
  #alias :url :default_url

  def url(*args)
    "/events"
  end
end