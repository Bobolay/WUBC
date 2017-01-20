class ArticlesController < ApplicationController
  caches_page :index

  def index
    articles_collection
    @page_banner = {
        title: "блог та новини"
    }

    @tags = Cms::Tag.all.joins(:articles).where(articles: { published: "t" }).includes(:translations, :taggings, :articles)
  end

  def show
    @article = Article.get(params[:id])
    if @article.nil?
      return render_not_found
    end

    if !current_user && @article.premium?
      return render_locked_article
    end



    set_page_metadata(@article)

    @page_banner = {
        image: @article.banner.exists?(:large) ? @article.banner.url(:large) : :default,
        default_image: "photo/article_default_banner.jpg"
    }

    tag_ids = @article.tags.pluck(:id)
    articles = Article.published.order_by_release_date.where.not(id: @article.id)
    if tag_ids.any?
      articles = articles.joins(taggings: { tag: {} }).where(cms_tags: { id: tag_ids }).uniq
    end

    articles = articles.limit(3)

    #@related_articles = @article.next(articles_collection, count: 3)
    @related_articles = articles
  end

  def articles_collection
    @articles ||= Article.published.order_by_release_date
  end
end