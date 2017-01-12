class MembersController < ApplicationController
  before_action :set_user, only: [:show]
  def index
    if !current_user
      return render_locked_members
    end
    @members = Member.confirmed.approved.not_speakers.order("approved_at desc")
    @names = @members.map{|m| {id: m.id, name_or_email: m.full_name_or_email(false)} }
    @companies = @members.map{|m| m.valid_companies }.flatten
    @industries = @companies.map{|c| {id: c.industry_id, name: c.industry_name } }.select(&:present?).uniq
    @regions = @companies.map(&:region).select(&:present?).uniq
    @companies_dropdown_options = @companies.map{|c| {id: c.id, name: c.name} }
  end

  def show
    if !current_user
      return render_locked_member
    end
  end

  private
  def set_user
    @user = User.where(id: params[:id]).first rescue nil
    if !@user
      return render_not_found
    end
  end
end