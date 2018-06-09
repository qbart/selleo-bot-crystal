require "openssl"

class Bot::Slack
  class Error < Exception
  end

  enum Color
    Good
    Warning
    Danger
  end

  struct Attachment
    getter title, text

    def initialize(@title : String, @text : String)
    end
  end

  struct User
    getter email

    def initialize(@id : String, @email : String)
    end
  end

  def find_user(id : String)
    client = JsonClient.new("slack.com")
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

  def post_response_info(url : String, title : String, attachments : Array(Attachment) = [] of Attachment)
    json = JSON.build do |json|
      json.object do
        json.field "text", title
        json.field "attachments" do
          json.array do
            attachments.each do |attachment|
              json.object do
                json.field "title", attachment.title
                json.field "text", attachment.text
              end
            end
          end
        end
      end
    end

    response = JsonClient.send_post(url, json)
    handle(response) {}
  end

  def post_response(url : String, title : String, text : String, color : Color, extra : String? = nil)
    json = JSON.build do |json|
      json.object do
        json.field "attachments" do
          json.array do
            json.object do
              json.field "title", title
              json.field "text", text
              json.field "color", color.to_s.downcase
              if !extra.nil?
                json.field "fields" do
                  json.array do
                    json.object do
                      json.field "value", extra
                      json.field "short", false
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    response = JsonClient.send_post(url, json)
    handle(response) {}
  end

  private def parse_email(body)
    pull = JSON::PullParser.new(body)
    pull.read_object do |key|
      case key
      when "error"
        raise Error.new(pull.read_string)
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

    raise Error.new("Slack API: Email not found")
  end

  private def handle(response)
    case response.status_code
    when 200, 201
      yield
    else
      raise Error.new("Slack API: Communication error")
    end
  end
end
