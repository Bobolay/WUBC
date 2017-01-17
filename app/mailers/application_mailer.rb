class ApplicationMailer < ActionMailer::Base
  default from: "support@wubc.club"
  layout 'mailer'
  helper Cms::Helpers::UrlHelper
  helper ApplicationHelper

  def receivers(name)
    config_class = "FormConfigs::#{name.classify}".constantize
    to = config_class.first.try(&:emails) || config_class.default_emails
    to
  end
end
