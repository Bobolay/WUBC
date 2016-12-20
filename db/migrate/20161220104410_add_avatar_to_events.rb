class AddAvatarToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.attachment :avatar
    end
  end
end
