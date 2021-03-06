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
    phone.gsub('(', '<span>(</span>').gsub(')', '<span>)</span>').html_safe
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
    #"+38 (063) 941 47 43"
    formatted_phone("+38 (068) 000 17 17")
  end

  def site_phone_link
    #"tel:+380639414743"
    "tel:+380680001717"
  end

  def site_email
    'westukrainianbusinessclub@gmail.com'
  end

  def facebook_url
    'https://www.facebook.com/westukrainianbusinessclub/'
  end

  def youtube_url
    'https://www.youtube.com/channel/UCv4hcWiiEzdyKZbFgoPlSXg'
  end

  def instagram_url
    'https://www.instagram.com/wubc_club/'
  end

  def background_youtube_video_url(youtube_video_id)
    "https://www.youtube.com/embed/#{youtube_video_id}?controls=0&showinfo=0&rel=0&autoplay=1&loop=1&playlist=#{youtube_video_id}&mute=1"
  end
end
