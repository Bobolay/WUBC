class CreateSpeakers < ActiveRecord::Migration
  def up
    create_table :speakers do |t|
      t.boolean :published
      t.integer :sorting_position
      t.string :name
      t.text :description
      t.attachment :image
      t.string :social_facebook
      t.string :social_google_plus

      t.timestamps null: false
    end

    Speaker.create_translation_table(:name, :description)
  end

  def down
    Speaker.drop_translation_table

    drop_table :speakers
  end
end
