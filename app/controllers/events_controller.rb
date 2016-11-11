class EventsController < ApplicationController
  before_action :set_event, only: [:show]
  def index
    @events = Event.published
    set_page_metadata(:events)
  end

  def show
    if @event
      set_page_metadata(@event)
    end
  end

  def set_event
    @event = Event.published.joins(:translations).where(event_translations: { url_fragment: params[:id], locale: I18n.locale }).first
    if !@event
      render_not_found
    end
  end
end