class EventsController < ApplicationController
  before_action :set_event, only: [:show, :subscribe, :unsubscribe]

  def index
    events_collection
    set_page_metadata(:events)
    @featured_event = Event.published.future.order("date asc").limit(1).first
  end

  def show
    if @event && !current_user && @event.premium? && @event.future?
      return render_locked_event
    end

    if @event
      set_page_metadata(@event)
      @next_event = @event.prev(events_collection, except_self: true, cycle: false)
      @prev_event = @event.next(events_collection, except_self: true, cycle: false)
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
    AdminMailer.user_subscribed_to_event(current_user, @event).deliver
    render json: { status: status }
  end

  def unsubscribe
    current_user.unsubscribe_from_event(@event)
    AdminMailer.user_unsubscribed_from_event(current_user, @event).deliver
    render json: { status: "OK" }
  end

end