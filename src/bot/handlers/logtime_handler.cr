require "./base_handler"

module Bot
  class LogTimeHandler < BaseHandler
    PREFIX = "logtime "

    def handle(user_id : String, response_url : String)
      slack = Slack.new
      dm3 = Dm3.new

      begin
        happix, entries = Logtime::ParseUserInput.call(text)
        user = slack.find_user(user_id)
        success_message = dm3.create_time_entries(email: user.email, happix: happix, time_entries: entries)
        slack.post_response(
          response_url,
          "Success",
          "Happix: #{happix}\n#{success_message}",
          Slack::Color::Good,
          command_log
        )

      rescue ex : Logtime::ParseUserInput::Error | TimeEntry::ParseErr | Dm3::Error | Slack::Error
        slack.post_response(
          response_url,
          "Failure",
          ex.message.not_nil!,
          Slack::Color::Danger,
          command_log
        )
      end
    end

    private def command_log
      "```#{ENV["SLACK_CMD"]} #{PREFIX}#{text}```"
    end
  end
end
