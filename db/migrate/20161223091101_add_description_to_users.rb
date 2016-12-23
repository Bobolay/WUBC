class AddDescriptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :description, :text
    add_column :user_translations, :description, :text
  end
end
