class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.boolean :published
      t.boolean :premium
      t.string :name
      t.text :content
      t.date :date
      t.time :start_time
      t.time :end_time

      t.timestamps null: false
    end

    Event.create_translation_table(:name, :content)
  end

  def down
    Event.drop_translation_table

    drop_table :events
  end
end
