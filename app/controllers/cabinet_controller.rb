class CabinetController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to cabinet_events_path
  end

  def events

  end

  def profile

  end

  def companies

  end
end