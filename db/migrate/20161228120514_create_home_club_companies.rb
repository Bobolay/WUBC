class CreateHomeClubCompanies < ActiveRecord::Migration
  def up
    create_table :home_club_companies do |t|
      t.boolean :published
      t.integer :sorting_position
      t.string :name
      t.text :description
      t.attachment :image

      t.timestamps null: false
    end

    HomeClubCompany.create_translation_table(:name, :description)
  end

  def down
    HomeClubCompany.drop_translation_table!

    drop_table :home_club_companies
  end
end
