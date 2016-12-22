class RenameUserRoleToType < ActiveRecord::Migration
  def up
    User.where("role='admin' OR role='administrator'").each{|u| u.update_attributes(role: "Administrator")}
    User.where(role: 'member').each{|u| u.update_attributes(role: "Member")}
    User.where("role is null OR role=''").each{|u| u.update_attributes(role: "Member")}
    rename_column :users, :role, :type
  end

  def down
    rename_column :users, :type, :role
  end
end
