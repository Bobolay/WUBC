class CreateHomeClubCompanies < ActiveRecord::Migration
  def up
    create_table :club_companies do |t|
      t.boolean :published
      t.integer :sorting_position
      t.string :name
      t.text :description
      t.attachment :image

      t.timestamps null: false
    end

    ClubCompany.create_translation_table(:name, :description)
  end

  def down
    ClubCompany.drop_translation_table!

    drop_table :club_companies
  end
end
