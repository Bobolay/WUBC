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
        path: ":rails_root/public:url",
        processors: [:thumbnail, :tinify]

  has_images :slider_images, styles: {large: "1370x600#", thumb: "274x120#", events_banner: "2048x500#"}, processors: [:thumbnail, :tinify], class_name: "EventGalleryImage"
  has_images :gallery_images, styles: { large: "1400x740#", small: "200x200#", thumb: "100x100#" }, processors: [:thumbnail, :tinify], class_name: "EventSlide"

  boolean_scope :published
  scope :past, -> { date = Date.today; time = Time.now; time_str = time.strftime("%H:%M");  where("date < ? OR (date = ? AND end_time < ?)", date, date, time_str) }
  scope :future, -> { date = Date.today; time = Time.now; time_str = time.strftime("%H:%M"); where("date > ? OR (date = ? AND start_time > ?)", date, date, time_str) }
  scope :active, -> { date = Date.today; time = Time.now; time_str = time.strftime("%H:%M"); where("date = ? AND start_time <= ? AND end_time >= ?", date, time_str, time_str) }
  scope :past_and_active, -> { date = Date.today; time = Time.now; time_str = time.strftime("%H:%M"); where("date < ? OR (date = ? AND start_time <= ?)", date, date, time_str) }
  scope :subscribed_by_user, ->(user) { return current_scope if user.nil?; current_scope.joins(:subscribed_users).where(event_subscriptions: { user_id: user.id }) }
  scope :visited_by_user, ->(user) { past_and_active.subscribed_by_user(user) }
  scope :home_future, -> { published.future.limit(3).order("date desc") }
  scope :home_past, -> { published.past_and_active.limit(3).order("date desc") }

  validates :date, :start_time, :end_time, presence: true, if: :published?

  has_and_belongs_to_many :subscribed_users, class_name: User, join_table: "event_subscriptions"
  attr_accessible :subscribed_users, :subscribed_user_ids

  has_many :event_speaker_bindings
  has_many :speakers, through: :event_speaker_bindings, class_name: User, foreign_key: :user_id
  attr_accessible :speaker_ids

  def to_param
    url_fragment
  end

  def start_date_time
    return nil if !self.date || !self.start_time
    DateTime.new(self.date.year, self.date.month, self.date.day, self.start_time.hour, self.start_time.min, 0, '+2')
  end

  def end_date_time
    return nil if !self.date || !self.end_time
    DateTime.new(self.date.year, self.date.month, self.date.day, self.end_time.hour, self.end_time.min, 0, '+2')
  end

  def event_date_time_range
    date_str = date ? "#{date.strftime('%d.%m.%Y')} " : ""

    time_range_str = "#{start_time ? start_time.strftime('%H:%M') : 'X'} &mdash; #{end_time ? end_time.strftime('%H:%M') : 'X'}"
    "#{date_str}#{time_range_str}".html_safe
  end

  def past?
    #date = Date.today;
    #time = Time.now;
    #event_end_time = end_time
    #event_end_time.year = date.year
    #event_end_time.month = event_end_time.month
    #event_end_time.day = event_end_time.day


    #self.date < date || (self.date == date && (end_date_time < time))
    date_time = DateTime.now
    date_time > end_date_time
  end

  def future?
    #date = Date.today
    #time = Time.now
    #self.date > date || (self.date == date && start_date_time > time)
    date_time = DateTime.now
    date_time < start_date_time
  end

  def active?
    #date = Date.today;
    #time = Time.now;
    #start_date_time = DateTime.new(self.date.year, self.date.month, self.date.day, self.start_time.hour, self.start_time.min)
    #end_date_time = DateTime.new(self.date.year, self.date.month, self.date.day, self.end_time.hour, self.end_time.min)
    #self.date == date && start_date_time >= time && end_date_time <= time
    date_time = DateTime.now
    date_time >= start_date_time && date_time <= end_date_time
  end

  def past_or_active?
    past? || active?
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
