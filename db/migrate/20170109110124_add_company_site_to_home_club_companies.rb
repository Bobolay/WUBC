class AddCompanySiteToHomeClubCompanies < ActiveRecord::Migration
  def change
    add_column :home_club_companies, :company_site, :string
  end
end
