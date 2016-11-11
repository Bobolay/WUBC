class AddUrlFragmentToEvents < ActiveRecord::Migration
  def change
    add_column :events, :url_fragment, :string
    add_column :event_translations, :url_fragment, :string
  end
end
