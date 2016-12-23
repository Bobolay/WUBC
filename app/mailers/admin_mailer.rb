class AdminMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.new_user_waiting_approval.subject
  #
  def new_user_waiting_approval(user)
    @greeting = "Hi"
    @admin_root = ENV["#{Rails.env}.host"] + "/#{I18n.locale}/admin"
    @user = user
    mail to: "to@example.org"
  end
end
