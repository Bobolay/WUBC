class PagesController < ApplicationController
  before_action :set_page_instance, except: [:index]

  def index
    set_page_metadata(:home)
    @future_events = Event.home_future
    @past_events = Event.home_past
  end

  def about_us

  end

  def partners

  end

  def contacts

  end

  private

  def set_page_instance
  #   set_page_metadata(action_name)
  end
end