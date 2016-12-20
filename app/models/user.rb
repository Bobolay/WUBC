class User < ActiveRecord::Base
  attr_accessible *attribute_names
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessible :password, :password_confirmation

  globalize :first_name, :last_name, :middle_name

  image :avatar, styles: { small: "72x72#" }
  crop_attached_file :avatar

  has_and_belongs_to_many :events_i_am_subscribed_on, class_name: Event
  attr_accessible :events_i_am_subscribed_on, :events_i_am_subscribed_on_ids

  def admin?
    role == "administrator" || role == "admin"
  end

  alias :administrator? :admin?

  def member?
    role == "member"
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
end

