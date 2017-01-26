class SessionsController < Users::SessionsController
  skip_all_before_action_callbacks
end