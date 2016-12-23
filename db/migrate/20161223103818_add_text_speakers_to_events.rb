class AddTextSpeakersToEvents < ActiveRecord::Migration
  def change
    add_column :events, :text_speakers, :text
    add_column :event_translations, :text_speakers, :text
  end
end
