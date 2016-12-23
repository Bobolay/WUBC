class RenameUserPhoneToPhones < ActiveRecord::Migration
  def up
    rename_column :users, :phone, :phones
    change_column :users, :phones, :text
  end

  def down
    rename_column :users, :phones, :phone
    change_column :users, :phone, :string
  end
end
