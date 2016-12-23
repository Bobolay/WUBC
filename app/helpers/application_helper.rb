module ApplicationHelper
  def main_menu
    menu([{url: root_path, key: "home"}, :about_us, :events, :articles, :members, :partners, :contacts])
  end

  def formatted_date(date, locale = I18n.locale)
    if date.blank?
      return ""
    end
    month_number = date.month
    month_name = Cms.t("genitive_month_names.#{month_number}")
    d = date.day
    m = month_name
    y = date.year
    ("#{d}<span>#{m} #{y}</span>").html_safe
  end

  def formatted_phone(phone)
    "+38 097 784 65 78"
  end

  def day_name(date)
    day_number = date.strftime("%u")
    Cms.t("day-names.#{day_number}")
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

end
