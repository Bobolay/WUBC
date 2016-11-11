class Event < ActiveRecord::Base
  attr_accessible *attribute_names

  globalize :name, :content, :url_fragment

  has_seo_tags
  has_sitemap_record

  boolean_scope :published
  scope :past, -> { date = Date.today; time = Time.now;  where("date < ? OR (date = ? AND end_time < ?)", date, date, time) }
  scope :future, -> { date = Date.today; time = Time.now; where("date > ? OR (date = ? AND start_time > ?)", date, date, time) }
  scope :active, -> { date = Date.today; time = Time.now; where("date = ? AND start_time >= ? AND end_time <= ?", date, time, time) }
  scope :past_and_active, -> { date = Date.today; time = Time.now; where("date < ? OR (date = ? AND end_time <= ?)", date, date, time) }
  scope :subscribed_by_user, ->(user) { current_scope }
  scope :visited_by_user, ->(user) { past_and_active.subscribed_by_user(user) }

  validates :date, :start_time, :end_time, presence: true, if: :published?

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


end
