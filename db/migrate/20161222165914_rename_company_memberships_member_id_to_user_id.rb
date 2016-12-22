class RenameCompanyMembershipsMemberIdToUserId < ActiveRecord::Migration
  def change
    rename_column :company_memberships, :member_id, :user_id
  end
end
