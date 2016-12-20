class CreateEventSubscriptions < ActiveRecord::Migration
  def change
    create_table :event_subscriptions do |t|
      t.integer :user_id
      t.integer :event_id
    end
  end
end
