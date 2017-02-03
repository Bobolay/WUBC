class CreatePersonalHelpers < ActiveRecord::Migration
  def up
    create_table :personal_helpers do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :phones

      t.timestamps null: false
    end

    PersonalHelper.create_translation_table(:first_name, :last_name)
  end

  def down
    PersonalHelper.drop_translation_table!

    drop_table :personal_helpers
  end
end
