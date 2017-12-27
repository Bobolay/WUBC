class AddCompanySiteToHomeClubCompanies < ActiveRecord::Migration
  def change
    add_column :club_companies, :company_site, :string
  end
end
