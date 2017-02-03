class PersonalHelper < ActiveRecord::Base
  attr_accessible *attribute_names

  include RecursiveParams

  belongs_to :user

  attr_accessible :user

  globalize :first_name, :last_name

  include HasPhones

  def name
    if first_name.blank? && last_name.blank?
      return "Особистий помічник ##{id}"
    end


    "#{first_name}#{ first_name.present? && last_name.present? ? ' ' : '' }#{last_name}"
  end
end
