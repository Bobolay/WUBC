class AddUrlToSpeaker < ActiveRecord::Migration
  def change
    add_column :speakers, :url, :string
  end
end
