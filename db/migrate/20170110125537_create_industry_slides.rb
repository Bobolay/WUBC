class CreateIndustrySlides < ActiveRecord::Migration
  def up
    create_table :industry_slides do |t|
      t.string :name
      t.attachment :image
      t.boolean :published
      t.integer :sorting_position

      t.timestamps null: false
    end

    IndustrySlide.create_translation_table(:name)
  end

  def down
    IndustrySlide.drop_translation_table!

    drop_table :club_member_values
  end
end
