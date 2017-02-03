class PagesController < ApplicationController
  before_action :set_page_instance, except: [:index]
  caches_page :index, :about_us, :partners, :contacts

  def index
    set_page_metadata(:home)
    @future_events = Event.home_future
    @past_events = Event.home_past
    @articles = Article.featured
    @slider_images = @page_instance.slider_images
    @testimonials = Testimonial.published.sort_by_sorting_position
    @speakers = Speaker.published.sort_by_sorting_position
    @club_companies = ClubCompany.published.featured.sort_by_sorting_position
  end

  def about_us
    @member_values = ClubMemberValue.published.sort_by_sorting_position
    @industry_slides = IndustrySlide.published.sort_by_sorting_position
  end

  def partners
    @club_companies = PartnerCompany.published.sort_by_sorting_position
  end

  def club_companies
    @club_companies = ClubCompany.published.unfeatured.sort_by_sorting_position
    render "partners"
  end

  def contacts

  end

  private

  def set_page_instance
     set_page_metadata(action_name)
  end
end