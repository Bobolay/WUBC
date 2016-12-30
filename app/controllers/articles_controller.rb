class ArticlesController < ApplicationController
  def index
    articles_collection
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

    if !current_user && @article.premium?
      return render_locked_article
    end



    set_page_metadata(@article)

    @page_banner = {
        image: @article.banner.url(:large)
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