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
    u = current_user


    #return render inline: "OK"
    if request.post?
      #params_user = user_params
      u.update_params(params[:user])

      return render json: {status: "OK"}, status: 200
    end

    render status: 403
  end

  def companies

  end

  def user_params
    params[:user].permit(:phone, :birth_date)
  end

  def user_translation_params
    params[:user].permit(:first_name, :last_name, :middle_name)
  end
end