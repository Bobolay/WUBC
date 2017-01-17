class MemberMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.new_user_waiting_approval.subject
  #
  def admin_approved_your_account(member, to = nil)
    to ||= member.email
    @admin_root = ENV["#{Rails.env}.host"] + "/admin"
    @member = member
    mail to: to, subject: "Ваш акаунт підтверджено адміністратором"
  end
end
