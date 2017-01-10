class AdminMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.new_user_waiting_approval.subject
  #
  def new_user_waiting_approval(user)
    @admin_root = "" #ENV["#{Rails.env}.host"] + "/admin"
    @user = user
    @email_title = "Новий користувач чекає на підтвердження"
    mail to: receivers("new_user_waiting_approval"), subject: @email_title, layout: "mailer"
  end

  def user_subscribed_to_event(member, event)
    @member = member
    @event = event
    @email_title = "Член клубу підписався на подію"
    mail to: receivers("user_subscribed_to_event"), subject: @email_title, layout: "mailer"
  end

  def user_unsubscribed_from_event(member, event)
    @member = member
    @event = event
    @email_title = "Член клубу відписався від події"
    mail to: receivers("user_unsubscribed_from_event"), subject: @email_title, layout: "mailer"
  end
end
