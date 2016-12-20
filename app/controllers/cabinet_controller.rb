class CabinetController < ApplicationController
  before_action :authenticate_user!

  def index
    #redirect_to cabinet_events_path
    @events = Event.subscribed_by_user(current_user)
    render "layouts/cabinet", layout: false
  end

  def events
  end

  def profile

  end

  def companies

  end
end