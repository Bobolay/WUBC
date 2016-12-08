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
end

