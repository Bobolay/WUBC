class ArticlesController < ApplicationController
  def index
    @articles = I18n.t("articles")
    @page_banner = {
        title: "блог та новини"
    }
  end

  def show
    @page_banner = {
        image: 'photo/banner-new-one.jpg'
    }
  end
end