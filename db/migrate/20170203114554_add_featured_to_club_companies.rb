class AddFeaturedToClubCompanies < ActiveRecord::Migration
  def change
    add_column :club_companies, :featured, :boolean
  end
end
