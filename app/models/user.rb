
class User < ActiveRecord::Base
  #set_inheritance_column :role
  include RecursiveParams

  attr_accessible *attribute_names
  attr_accessible :approved, :company_ids
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessible :password, :password_confirmation, :remember_me

  globalize :first_name, :last_name, :middle_name, :description, :hobby

  image :avatar, styles: { small: "72x72#", member: "620x620#", cabinet: "240x240#", thumb: "100x100#" }
  crop_attached_file :avatar

  has_and_belongs_to_many :events_i_am_subscribed_on, class_name: Event, join_table: "event_subscriptions"
  attr_accessible :events_i_am_subscribed_on, :events_i_am_subscribed_on_ids

  has_many :company_memberships
  has_many :companies, through: :company_memberships, autosave: true

  has_many :event_speaker_bindings
  has_many :events_with_me_as_speaker, through: :event_speaker_bindings, source: :event, foreign_key: :speaker_idm, class_name: Event

  scope :confirmed, -> { where("confirmed_at is not null") }
  scope :approved, -> { where("approved_at is not null") }

  boolean_scope :is_speaker, :speakers, :not_speakers

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

  def formatted_ages
    c = ages
    return "" if !c
    one = "рік"
    many = "років"
    few = "роки"

    res = c % 10
    str = ""
    if res == 1
      "#{c} #{one}"
    elsif res >= 2 && res <= 4
      "#{c} #{few}"
    else
      "#{c} #{many}"
    end
  end

  def phones
    [phone]
  end

  def approved
    approved_at.present?
  end

  def approved?
    approved
  end

  def approved=(value)
    ok = value == "1"
    puts "value: #{ok.inspect}"
    self.approved_at = ok ? DateTime.now : nil

  end

  def inactive_message
    if !confirmed_at?
      :not_confirmed
    elsif !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def active_for_authentication?
    super && (admin? || approved?)
  end

  after_save :send_admin_mail
  def send_admin_mail(force = false)
    if force || (self.confirmed_at && self.confirmed_at_changed?) && !self.approved?
      AdminMailer.new_user_waiting_approval(self).deliver
    end

    true
  end

  def send_admin_mail!
    send_admin_mail(true)
  end

  after_save :send_approval_congratulations
  def send_approval_congratulations(force = false, emails = self.email)
    return false if !self.respond_to?(:approved_at_changed?)
    if force || self.confirmed_at && self.approved_at_changed? && self.approved?
      MemberMailer.admin_approved_your_account(self, emails).deliver
    end
  end

  def send_approval_congratulations!
    send_approval_congratulations(true)
  end

  def notify_admin_about_subscription(event)
    AdminMailer.user_subscribed_to_event(self, event).deliver
  end

  def notify_admin_about_unsubscription(event)
    AdminMailer.user_unsubscribed_from_event(self, event).deliver
  end

  def user_data
    user_columns = [:first_name, :middle_name, :last_name, :hobby, :phones, :email, :hobby]
    h = Hash[user_columns.map{|k|
      [k, self.send(k)]
    }]



    h[:birth_date] = birth_date.present? ? birth_date.strftime("%d.%m.%Y") : nil
    h[:social_networks] = social_links


    h
  end

  def companies_data
    companies.map do |company|
      {name: company.name,
       description: company.description,
       position: company.position,
       region: company.region,
       industry: company.industry_name,
       company_site: company.company_site,
       employees_count: company.employees_count,
       offices: company.company_offices.map do |office|
         { city: office.city, address: office.address, phones: office.phones }
       end,
       social_networks: company.social_links
      }
    end
  end

  def valid_companies
    required_fields = [:name, :industry, :region, :position, :employees_count]
    companies.to_a.select{|c|
      valid = true
      required_fields.each do |f|
        if c.send(f).blank?
          valid = false
          break
        end
      end

      valid
    }
  end

  def phones=(val)
    puts "phones: #{val}"
    if val.is_a?(Array)
      val = val.join("\r\n")
    end

    puts "phones: formatted: #{val}"

    self['phones'] = val

    true
  end

  def phones(parse = true)
    val = self['phones']
    if parse
      if val.blank?
        return []
      end
      return self['phones'].split("\r\n")
    else
      return self['phones']
    end
  end

  def social_links
    Hash[[:facebook, :google_plus].map{|k| [k, send("social_#{k}") ]  }.select{|item| item[1].present? }]
  end

  def member_regions(format = false)
    items = valid_companies.map(&:region)
    if format
      items.join(",")
    else
      items
    end
  end

  def member_industry_ids(format = false)
    arr = valid_companies.map{|c| c.industry.try(:id) }.select(&:present?).uniq
    if format
      arr.join(",")
    else
      arr
    end
  end

  def member_company_ids(format = false)
    arr = valid_companies.map(&:id)
    if format
      arr.join(",")
    else
      arr
    end
  end
end

