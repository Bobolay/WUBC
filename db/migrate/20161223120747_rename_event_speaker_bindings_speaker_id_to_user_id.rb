class RenameEventSpeakerBindingsSpeakerIdToUserId < ActiveRecord::Migration
  def change
    rename_column :event_speaker_bindings, :speaker_id, :user_id
  end
end
