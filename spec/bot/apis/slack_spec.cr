require "../../../spec_helper"

Mocks.create_mock JsonClient do
  mock self.send_post(url, body)
end

describe Bot::Slack do
  describe "#find_user" do
    it "returns user data" do
      WebMock.stub(:get, "https://slack.com/api/users.profile.get?token=access-token&user=1").
        to_return(body: <<-BODY
          {
            "profile": {
              "email": "batman@cave.com"
            }
          }
          BODY
        )

      user = Bot::Slack.new.find_user("1")

      user.email.should eq "batman@cave.com"
    end

    it "returns user data" do
      WebMock.stub(:get, "https://slack.com/api/users.profile.get?token=access-token&user=1").
        to_return(body: <<-BODY
          {
            "error": "Oops"
          }
          BODY
        )

      expect_raises(Bot::Slack::Error, "Oops") do
        Bot::Slack.new.find_user("1")
      end
    end

    it "raises error when invalid status" do
      WebMock.stub(:get, "https://slack.com/api/users.profile.get?token=access-token&user=1").
        to_return(status: 404, body: "")

      expect_raises(Bot::Slack::Error, "Slack API: Communication error") do
        Bot::Slack.new.find_user("1")
      end
    end
  end

  describe "#post_response" do
    # mocks library is broken, cannot properly stub methods
    pending "sends formatted message" do
      WebMock.stub(:post, "http://response.dev").to_return(body: "")

      Bot::Slack.new.post_response(
        "http://response.dev",
        "Star Wars",
        "Long time ago...",
        Bot::Slack::Color::Good,
        ";)"
      )

      JsonClient.should have_received(self.send_post(
        "http://response.dev",
        %<{"attachments":[{"title":"Star Wars","text":"Long time ago...","color":"good","fields":[{"value":";)","short":false}]}]}>
      ))
    end

    it "raises error when invalid status" do
      WebMock.stub(:post, "http://response.dev").to_return(status: 500, body: "")

      expect_raises(Bot::Slack::Error, "Slack API: Communication error") do
        Bot::Slack.new.post_response(
          "http://response.dev",
          "Star Wars",
          "Long time ago...",
          Bot::Slack::Color::Good,
          ";)"
        )
      end
    end
  end
end
