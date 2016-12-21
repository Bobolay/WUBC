class CreateCompanyMemberships < ActiveRecord::Migration
  def change
    create_table :company_memberships do |t|
      #t.belongs_to :company, index: true, foreign_key: true
      #t.belongs_to :member, index: true, foreign_key: true
      t.integer :company_id
      t.integer :member_id
      t.timestamps null: false
    end
  end
end
