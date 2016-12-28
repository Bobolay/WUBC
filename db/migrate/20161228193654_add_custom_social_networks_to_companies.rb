class AddCustomSocialNetworksToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :social_facebook, :string
    add_column :companies, :social_google_plus, :string
  end
end
