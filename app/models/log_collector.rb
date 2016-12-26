if Rails.env.development?
  require 'sshkit'
  require 'sshkit/dsl'
  include SSHKit::DSL
end

class LogCollector
  def download_logs

  end
end