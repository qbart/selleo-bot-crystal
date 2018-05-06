require "./base_handler"

module Bot
  class LogTimeHandler < BaseHandler
    class ParseUserInputErr < Exception
    end

    PREFIX = "logtime "

    def handle(user_id : String, response_url : String)
      slack = Slack.new
      dm3 = Dm3.new

      begin
        happix, entries = Logtime::ParseUserInput.call(text)
        user = slack.find_user(user_id)
        dm3.create_time_entries(email: user.email, happix: happix, time_entries: entries)

      rescue ex : Logtime::ParseUserInput::Error | TimeEntry::ParseErr | Dm3::Error | Slack::Error
        slack.post_response(response_url, "Failure", ex.message.not_nil!, Slack::Color::Danger)
      else
        slack.post_response(response_url, "Success", "Happix: #{happix}\n", Slack::Color::Good)
      end
    end
  end
end