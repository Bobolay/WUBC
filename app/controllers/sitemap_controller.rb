class SitemapController < ApplicationController
  skip_all_before_action_callbacks

  def index
    @entries = Cms::SitemapElement.entries_for_resources(nil, Cms.config.provided_locales)

    render "cms/sitemap/index"
  end
end