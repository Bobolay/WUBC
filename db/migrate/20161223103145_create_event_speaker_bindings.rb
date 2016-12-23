class CreateEventSpeakerBindings < ActiveRecord::Migration
  def change
    create_table :event_speaker_bindings do |t|
      t.integer :event_id
      t.integer :speaker_id

      t.timestamps null: false
    end
  end
end
