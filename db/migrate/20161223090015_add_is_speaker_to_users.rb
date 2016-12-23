class AddIsSpeakerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_speaker, :boolean
  end
end
