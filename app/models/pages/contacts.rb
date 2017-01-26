class Pages::Contacts < Cms::Page
  #alias :url :default_url
  def url(*args)
    "/contacts"
  end
end