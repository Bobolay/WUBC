ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 25, # 587
    :domain               => ENV["smtp_gmail_domain"],
    :user_name            => ENV["smtp_gmail_user_name"],
    :password             => ENV["smtp_gmail_password"],
    :authentication       => "plain",
    :enable_starttls_auto => true # default: true
}

