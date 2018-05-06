require "./base_handler"

module Bot
  class LogTimeHandler < BaseHandler
    class ParseUserInputErr < Exception
    end

    PREFIX = "logtime "

    def handle(user_id : String, response_url : String)
      slack = Apis::Slack.new
      dm3 = Bot::Dm3.new

      begin
        happix, entries = parse_time_entries
        user = slack.find_user(user_id)
        dm3.create_time_entries(email: user.email, happix: happix, time_entries: entries)

      rescue ex : ParseUserInputErr | Bot::TimeEntry::ParseErr
        slack.post_response(response_url, "Failure", ex.message.not_nil!, Apis::Slack::Color::Danger)
      else
        slack.post_response(response_url, "Success", "Happix: #{happix}\n", Apis::Slack::Color::Good)
      end
    end

    private def parse_time_entries : {Int32, Array(TimeEntry)}
      lines = text.split("\n").map { |line| line.strip }
      if lines.size >= 2
        happix_line = lines.shift
        if happix_line =~ /^\d+$/
          happix = happix_line.to_i
          entries = lines.map { |line| TimeEntry.parse(line) }
          return {happix, entries}
        end
      end

      raise ParseUserInputErr.new("Unable to parse input:\n#{text}")
    end
  end
end