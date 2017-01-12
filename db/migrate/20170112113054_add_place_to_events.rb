class AddPlaceToEvents < ActiveRecord::Migration
  def change
    add_column :events, :place, :text
    add_column :event_translations, :place, :text
  end
end
