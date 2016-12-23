class CompanyMembership < ActiveRecord::Base
  belongs_to :company
  belongs_to :user, class_name: User, foreign_key: "user_id"


end
