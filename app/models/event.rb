class Event < ActiveRecord::Base
  attr_accessible *attribute_names

  globalize :name, :content, :url_fragment, :text_speakers

  has_seo_tags
  has_sitemap_record

  image :avatar, styles: {list: "500x275#", thumb: "152x100#"}

  has_images :slider_images, styles: {large: "1370x600#", thumb: "274x120#"}
  has_images :gallery_images, styles: { large: "1400x740#", small: "200x200#", thumb: "100x100#" }

  boolean_scope :published
  scope :past, -> { date = Date.today; time = Time.now;  where("date < ? OR (date = ? AND end_time < ?)", date, date, time) }
  scope :future, -> { date = Date.today; time = Time.now; where("date > ? OR (date = ? AND start_time > ?)", date, date, time) }
  scope :active, -> { date = Date.today; time = Time.now; where("date = ? AND start_time >= ? AND end_time <= ?", date, time, time) }
  scope :past_and_active, -> { date = Date.today; time = Time.now; where("date < ? OR (date = ? AND end_time <= ?)", date, date, time) }
  scope :subscribed_by_user, ->(user) { return current_scope if user.nil?; current_scope.joins(:subscribed_users).where(event_subscriptions: { user_id: user.id }) }
  scope :visited_by_user, ->(user) { past_and_active.subscribed_by_user(user) }
  scope :home_future, -> { published.future.limit(3) }
  scope :home_past, -> { published.past.limit(3) }

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

  def text_speakers_array
    (text_speakers || "").split("\r\n")
  end


end
