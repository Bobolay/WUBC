class Article < ActiveRecord::Base
  attr_accessible *attribute_names
  extend Enumerize

  belongs_to :author, class_name: Administrator

  enumerize :article_type, in: [:blog, :news], default: :blog

  image :banner, styles: {large: "2048x400#"}, processors: [:tinify]
  image :avatar, styles: { list: "500x250#" }, processors: [:tinify]

  globalize :name, :url_fragment, :content

  boolean_scope :published
  boolean_scope :premium
  scope :order_by_release_date, -> { order("release_date desc") }
  scope :featured, -> { published.order_by_release_date.limit(3) }
  scope :public_articles, -> { published.unpremium }

  has_seo_tags
  has_sitemap_record
  has_cache do
    pages :home, :articles, self, Article.public_articles
  end

  def url(locale = I18n.locale)
    "/articles/#{translations_by_locale[locale].url_fragment}"
  end

  has_tags

  before_save :initialize_release_date

  def initialize_release_date
    self.release_date = Date.today if self.release_date.blank?
  end

  def self.get(url_fragment)
    self.published.includes(:translations).where(article_translations: { url_fragment: url_fragment, locale: I18n.locale }).first
  end

  def public?
    published && !premium?
  end


end

# [Article, Event, IndustrySlide, Speaker, Testimonial, User].each(&:reprocess_attachments)
# [Event].each{|m| m.all.each(&:reprocess_all) }
