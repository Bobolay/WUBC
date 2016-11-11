class ArticlesController < ApplicationController
  def index
    @articles = I18n.t("articles")
  end

  def show

  end
end