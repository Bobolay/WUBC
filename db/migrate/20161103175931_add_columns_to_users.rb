class AddColumnsToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.date :birth_date
      t.string :phone
      t.attachment :avatar
    end

    User.create_translation_table(:first_name, :last_name, :middle_name)
  end

  def down
    [:first_name, :last_name, :middle_name, :phone, :birth_date, :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at].each do |c|
      remove_column :users, c
    end

    User.drop_translation_table!
  end
end
