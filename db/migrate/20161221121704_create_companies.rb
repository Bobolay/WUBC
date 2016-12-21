class CreateCompanies < ActiveRecord::Migration
  def up
    create_table :companies do |t|
      t.integer :member
      t.string :name
      t.integer :industry_id
      t.text :description
      t.string :region
      t.string :position
      t.integer :employees_count
      t.string :company_site
      t.text :social_networks

      t.timestamps null: false
    end

    Company.create_translation_table(:name, :description, :region, :position)
  end

  def down
    Company.drop_translation_table!

    drop_table :companies
  end
end
