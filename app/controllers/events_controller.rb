class EventsController < ApplicationController
  before_action :set_event, only: [:show, :subscribe, :unsubscribe]

  def index
    @events = Event.published.order("date desc")
    set_page_metadata(:events)
    @featured_event = Event.first
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

  def subscribe
    if @event.premium? && !current_user
      return render status: 403
    end


    status = current_user.subscribe_on_event(@event)
    render json: { status: status }
  end

  def unsubscribe
    current_user.unsubscribe_from_event(@event)

    render json: { status: "OK" }
  end
end