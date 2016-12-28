class PagesController < ApplicationController
  before_action :set_page_instance, except: [:index]

  def index
    set_page_metadata(:home)
    @future_events = Event.home_future
    @past_events = Event.home_past
    @articles = Article.featured
    @slider_images = @page_instance.slider_images
    @testimonials = Testimonial.published.sort_by_sorting_position
    @speakers = Speaker.published
    @club_companies = HomeClubCompany.published.sort_by_sorting_position
  end

  def about_us

  end

  def events

  end

  def members

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