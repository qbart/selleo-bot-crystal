require "openssl"

class Bot::Apis::Slack
  class ApiError < Exception
  end

  enum Color
    Good
    Warning
    Danger
  end

  struct User
    def initialize(@id : String, @email : String)
    end
  end

  def find_user(id : String)
    client = HTTP::Client.new("slack.com", tls: true)
    encoded_params = HTTP::Params.build do |builder|
      builder.add "token", ENV["SLACK_ACCESS_TOKEN"]
      builder.add "user", id
    end

    response = client.get "/api/users.profile.get?#{encoded_params}"
    handle response do
      email = parse_email(response.body)
      User.new(id, email)
    end
  end

  def post_response(url : String, title : String, text : String, color : Color)
    json = JSON.build do |json|
      json.object do
        json.field "attachments" do
          json.array do
            json.object do
              json.field "title", title
              json.field "text", text
              json.field "color", color.to_s.downcase
            end
          end
        end
      end
    end

    HTTP::Client.post(url, headers: HTTP::Headers{"Content-type" => "application/json"}, body: json)
  end

  private def parse_email(body)
    pull = JSON::PullParser.new(body)
    pull.read_object do |key|
      case key
      when "error"
        raise ApiError.new(pull.read_string)
      when "profile"
        pull.read_object do |profile|
          if profile == "email"
            return pull.read_string
          end
          pull.skip
        end
      else
        pull.skip
      end
    end

    raise ApiError.new("Email not found")
  end

  private def handle(response)
    case response.status_code
    when 200, 201
      yield
    else
      raise ApiError.new("Error with Slack API communication")
    end
  end
end
