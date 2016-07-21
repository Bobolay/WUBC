class PagesController < ApplicationController
  before_action :set_page_instance, except: [:index]

  self.layout "home"

  def main
  #   set_page_metadata(:home)
  end

  def about_us

  end

  private

  def set_page_instance
  #   set_page_metadata(action_name)
  end
end