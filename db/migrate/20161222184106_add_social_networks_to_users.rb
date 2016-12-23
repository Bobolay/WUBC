class AddSocialNetworksToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :social_twitter
      t.string :social_google_plus
      t.string :social_facebook
      t.string :social_linkedin
      t.string :social_vk
    end
  end
end
