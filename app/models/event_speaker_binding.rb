class EventSpeakerBinding < ActiveRecord::Base
  belongs_to :speaker, class_name: User, foreign_key: :user_id
  belongs_to :event
end
