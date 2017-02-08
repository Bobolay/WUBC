module ApplicationHelper
  def main_menu
    menu([{url: root_path, key: "home"}, :about_us, :events, :articles, {key: "members", for_users_only: true}, :club_companies, :contacts])
  end

  def formatted_date(date, locale = I18n.locale)
    if date.blank?
      return ""
    end
    month_number = date.month
    month_name = Cms.t("genitive_month_names.month-#{month_number}")
    d = date.day
    m = month_name
    y = date.year
    ("#{d}<span>#{m} #{y}</span>").html_safe
  end

  def formatted_phone(phone)
    phone
  end

  def day_name(date)
    day_number = date.strftime("%u")
    Cms.t("day-names.day-#{day_number}")
  end

  def formatted_time_range(time1, time2)
    "#{time1.strftime("%H:%M")} по #{time2.strftime("%H:%M")}"
  end

  def resource
    current_user || User.new
  end

  def resource_name
    :user
  end

  def devise_mapping
    Devise.mappings[:user]
  end


  def resource_class
    devise_mapping.to
  end

  def formatted_site_phone
    "+38 (067) 866 71 13"
  end

  def site_phone_link
    "tel:+380678667113"
  end

end
