class User < ActiveRecord::Base
  #set_inheritance_column :role

  attr_accessible *attribute_names
  attr_accessible :approved, :company_ids
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessible :password, :password_confirmation

  globalize :first_name, :last_name, :middle_name

  image :avatar, styles: { small: "72x72#", member: "325x325#", thumb: "100x100#" }
  crop_attached_file :avatar

  has_and_belongs_to_many :events_i_am_subscribed_on, class_name: Event, join_table: "event_subscriptions"
  attr_accessible :events_i_am_subscribed_on, :events_i_am_subscribed_on_ids

  has_many :company_memberships
  has_many :companies, through: :company_memberships

  scope :confirmed, -> { where("confirmed_at is not null") }
  scope :approved, -> { where("approved_at is not null") }

  def admin?
    type == "Administrator"
  end

  alias :administrator? :admin?

  def member?
    type == "Member"
  end

  def full_name(include_middle_name = true, include_last_name = true)
    arr = [first_name]
    if include_middle_name
      arr << middle_name
    end
    if include_last_name
      arr << last_name
    end

    arr.select(&:present?).join(" ")
  end

  def full_name_or_email(include_middle_name = true, include_last_name = true)
    str = full_name(include_middle_name, include_last_name)
    str = email if str.blank?

    str
  end

  def subscribed_on_event?(event)
    !EventSubscription.where(event_id: event.id, user_id: self.id).first.nil?
  end

  def subscribe_on_event(event)
    if !subscribed_on_event?(event)
      es = EventSubscription.new(event_id: event.id, user_id: self.id)
      es.save
    end
  end

  def unsubscribe_from_event(event)
    if subscribed_on_event?(event)
      es = EventSubscription.where(event_id: event.id, user_id: self.id)
      es.delete_all
    end
  end

  def ages
    return nil if birth_date.blank?
    Date.today.year - birth_date.year
  end

  def phones
    [phone]
  end

  def approved
    approved_at.present?
  end

  def approved=(value)
    ok = value == "1"
    puts "value: #{ok.inspect}"
    self.approved_at = ok ? DateTime.now : nil

  end
end

