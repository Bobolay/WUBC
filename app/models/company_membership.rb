class CompanyMembership < ActiveRecord::Base
  belongs_to :company
  belongs_to :member, class_name: User, foreign_key: "member_id"
end
