class CreateTestimonials < ActiveRecord::Migration
  def up
    create_table :testimonials do |t|
      t.boolean :published
      t.integer :sorting_position
      t.string :name
      t.string :position
      t.text :description
      t.attachment :image

      t.timestamps null: false
    end

    Testimonial.create_translation_table(:name, :position, :description)
  end

  def down
    Testimonial.drop_translation_table

    drop_table :testimonials
  end
end
