class User < ActiveRecord::Base
  attr_accessible *attribute_names
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :password, :password_confirmation

  globalize :first_name, :last_name, :middle_name

  image :avatar

  def admin?
    role == "administrator"
  end

  alias :administrator? :admin?

  def member?
    role == "member"
  end

  def full_name(include_middle_name = true)
    if include_middle_name
      arr = [first_name, middle_name, last_name]
    else
      arr = [first_name, last_name]
    end

    arr.select(&:present?).join(" ")
  end

  def full_name_or_email(include_middle_name = true)
    str = full_name(include_middle_name)
    str = email if str.blank?

    str
  end
end

