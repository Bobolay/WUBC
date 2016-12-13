class CreateArticles < ActiveRecord::Migration
  def up
    create_table :articles do |t|
      t.string :name
      t.string :url_fragment
      t.text :content
      t.date :release_date
      t.boolean :published
      t.boolean :premium
      t.attachment :banner
      t.attachment :avatar
      t.integer :author_id
      t.string :article_type

      t.timestamps null: false
    end

    Article.create_translation_table(:name, :url_fragment, :content)
  end

  def down
    Article.drop_translation_table!

    drop_table :articles
  end
end
