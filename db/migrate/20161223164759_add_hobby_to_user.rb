class AddHobbyToUser < ActiveRecord::Migration
  def change
    add_column :users, :hobby, :text
    add_column :user_translations, :hobby, :text
  end
end
