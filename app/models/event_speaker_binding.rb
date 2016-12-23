class EventSpeakerBinding < ActiveRecord::Base
  belongs_to :speaker, class_name: User
  belongs_to :event
end
