class ArticlesController < ApplicationController
  def index
    @articles = Article.published.order_by_release_date
    @page_banner = {
        title: "блог та новини"
    }

    @tags = Cms::Tag.all.joins(:articles).where(articles: { published: "t" }).includes(:translations, :taggings, :articles)
  end

  def show
    @article = Article.published.includes(:translations).where(article_translations: { url_fragment: params[:id] }).first
    if @article.nil?
      return render_not_found
    end

    set_page_metadata(@article)

    @page_banner = {
        image: @article.banner.url(:large)
    }
  end
end