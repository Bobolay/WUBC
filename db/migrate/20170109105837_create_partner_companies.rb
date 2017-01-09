class CreatePartnerCompanies < ActiveRecord::Migration
  def up
    create_table :partner_companies do |t|
      t.boolean :published
      t.integer :sorting_position
      t.string :name
      t.string :company_site
      t.text :description
      t.attachment :image

      t.timestamps null: false
    end

    PartnerCompany.create_translation_table(:name, :description)
  end

  def down
    PartnerCompany.drop_translation_table!

    drop_table :partner_companies
  end
end
