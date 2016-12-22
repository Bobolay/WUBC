class CreateCompanyOffices < ActiveRecord::Migration
  def up
    create_table :company_offices do |t|
      t.integer :company_id
      t.string :city
      t.string :address
      t.text :phones

      t.timestamps null: false
    end

    CompanyOffice.create_translation_table(:city, :address)
  end

  def down
    CompanyOffice.drop_translation_table!

    drop_table :company_offices
  end
end
