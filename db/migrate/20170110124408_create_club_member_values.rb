class CreateClubMemberValues < ActiveRecord::Migration
  def up
    create_table :club_member_values do |t|
      t.string :name
      t.text :description
      t.boolean :published
      t.integer :sorting_position


      t.timestamps null: false
    end

    ClubMemberValue.create_translation_table(:name, :description)
  end

  def down
    ClubMemberValue.drop_translation_table!

    drop_table :club_member_values
  end
end
