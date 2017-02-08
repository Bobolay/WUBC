class CreateCompaniesRegions < ActiveRecord::Migration
  def change
    create_table :companies_regions do |t|
      t.integer :company_id
      t.integer :region_id
    end
  end
end
