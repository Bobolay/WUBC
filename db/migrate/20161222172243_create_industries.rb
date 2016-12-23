class CreateIndustries < ActiveRecord::Migration
  def up
    create_table :industries do |t|
      t.string :name

      t.timestamps null: false
    end

    Industry.create_translation_table(:name)
  end

  def down
    Industry.drop_translation_table

    drop_table :industries
  end
end
