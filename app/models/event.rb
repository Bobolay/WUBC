class Event < ActiveRecord::Base
  attr_accessible *attribute_names

  globalize :name, :content, :url_fragment, :text_speakers, :place

  has_seo_tags
  has_sitemap_record
  has_cache do
    pages :home, :events, self, Event.published
  end

  def url(locale = I18n.locale)
    "/events/#{translations_by_locale[locale].url_fragment}"
  end

  image :avatar, styles: {list: "500x275#", thumb: "152x100#", navigation_avatar: "200x200#"},
        url: "/system/:class/:attachment/:id_partition/:style/:filename",
        path: ":rails_root/public:url"

  has_images :slider_images, styles: {large: "1370x600#", thumb: "274x120#", events_banner: "2048x500#"}, class_name: "EventGalleryImage"
  has_images :gallery_images, styles: { large: "1400x740#", small: "200x200#", thumb: "100x100#" }, class_name: "EventSlide"

  boolean_scope :published
  scope :past, -> { date = Date.today; time = Time.now;  where("date < ? OR (date = ? AND end_time < ?)", date, date, time) }
  scope :future, -> { date = Date.today; time = Time.now; where("date > ? OR (date = ? AND start_time > ?)", date, date, time) }
  scope :active, -> { date = Date.today; time = Time.now; where("date = ? AND start_time >= ? AND end_time <= ?", date, time, time) }
  scope :past_and_active, -> { date = Date.today; time = Time.now; where("date < ? OR (date = ? AND end_time <= ?)", date, date, time) }
  scope :subscribed_by_user, ->(user) { return current_scope if user.nil?; current_scope.joins(:subscribed_users).where(event_subscriptions: { user_id: user.id }) }
  scope :visited_by_user, ->(user) { past_and_active.subscribed_by_user(user) }
  scope :home_future, -> { published.future.limit(3).order("date desc") }
  scope :home_past, -> { published.past.limit(3).order("date desc") }

  validates :date, :start_time, :end_time, presence: true, if: :published?

  has_and_belongs_to_many :subscribed_users, class_name: User, join_table: "event_subscriptions"
  attr_accessible :subscribed_users, :subscribed_user_ids

  has_many :event_speaker_bindings
  has_many :speakers, through: :event_speaker_bindings, class_name: User, foreign_key: :user_id
  attr_accessible :speaker_ids

  def to_param
    url_fragment
  end

  def past?
    date = Date.today;
    time = Time.now;
    self.date < date || (self.date == date && end_time < time)
  end

  def future?
    date = Date.today;
    time = Time.now;
    self.date > date || (self.date == date && start_time > time)
  end

  def active?
    date = Date.today;
    time = Time.now;
    self.date == date && start_time >= time && end_time <= time
  end

  def public?
    published && (past? || !premium?)
  end

  def text_speakers_array
    (text_speakers || "").split("\r\n")
  end


  def self.get(url_fragment)
    self.published.joins(:translations).where(event_translations: { url_fragment: url_fragment, locale: I18n.locale }).first
  end

end
