require "./base_handler"

module Bot
  class LogTimeHandler < BaseHandler
    PREFIX = "logtime "

    def handle(user_id : String, response_url : String)
      slack = Apis::Slack.new
      user = slack.find_user(user_id)
      log text
      slack.post_response(response_url, "title", "text body", Apis::Slack::Color::Danger)
    end
  end
end