class EventsController < ApplicationController
  before_action :set_event, only: [:show, :subscribe, :unsubscribe]

  def index
    events_collection
    set_page_metadata(:events)
    @featured_event = Event.published.future.order("date asc").limit(1).first
  end

  def show
    if @event && !current_user && @event.premium? && @event.future?
      @white_bg = true
      return render "locked"
    end

    if @event

      set_page_metadata(@event)
      @next_event = @event.next(events_collection, except_self: true)
      @prev_event = @event.prev(events_collection, except_self: true)
    end

  end

  def events_collection
    @events ||= Event.published.order("date desc")
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

  def locked
    @white_bg = true
  end

end