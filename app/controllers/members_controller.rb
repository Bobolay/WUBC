class MembersController < ApplicationController
  before_action :set_user, only: [:show]
  def index
    @members = Member.confirmed.approved.not_speakers.order("approved_at desc")
  end

  def show

  end

  private
  def set_user
    @user = User.where(id: params[:id]).first rescue nil
    if !@user
      return render_not_found
    end
  end
end