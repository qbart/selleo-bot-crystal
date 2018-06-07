require "./base_handler"
require "./logtime_handler"

module Bot
  class HelpHandler < BaseHandler
    PREFIX = "help"

    def handle(user_id : String, response_url : String)
      slack = Slack.new

      slack.post_response_info(
        response_url,
        "List of commands:",
        [logtime]
      )
    end

    private def logtime
      Slack::Attachment.new(
        "Worklog",
        "#{ENV["SLACK_CMD"]} #{LogtimeHandler::PREFIX}`&lt;happix&gt;`\n" \
          "`&lt;time entries&gt;`\n\n" \
          "```" \
          "#{ENV["SLACK_CMD"]} #{LogtimeHandler::PREFIX}3\n" \
          "2018-01-01 09:00 11:00 ticket-1\n" \
          "2018-01-01 11:00 17:00 ticket-2\n" \
          "```\n" \
          "```\n" \
          "#{ENV["SLACK_CMD"]} #{LogtimeHandler::PREFIX}3\n" \
          "09:00 11:00 ticket-1\n" \
          "11:00 17:00 ticket-2\n" \
          "```"
      )
    end
  end
end
