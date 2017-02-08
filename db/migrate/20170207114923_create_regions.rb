class CreateRegions < ActiveRecord::Migration
  def up
    create_table :regions do |t|
      t.string :name

      t.timestamps null: false
    end

    Region.create_translation_table(:name)
  end

  def down
    Region.drop_translation_table!

    drop_table :regions
  end
end
