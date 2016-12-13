class Article < ActiveRecord::Base
  attr_accessible *attribute_names
  extend Enumerize

  belongs_to :author, class_name: Administrator

  enumerize :article_type, in: [:blog, :news], default: :blog

  image :banner, styles: {large: "2048x400#"}
  image :avatar, styles: { list: "500x250#" }

  globalize :name, :url_fragment, :content

  boolean_scope :published
  scope :order_by_release_date, -> { order("release_date desc") }

  has_cache
  def url(locale = I18n.locale)
    "/#{locale}/articles/#{translations_by_locale[locale].url_fragment}"
  end

  has_tags


end
