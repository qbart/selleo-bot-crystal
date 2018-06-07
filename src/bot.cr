require "kemal"
require "dotenv"
require "./bot/**"
require "./middlewares/slack_verifier"

Bot::Env.load

get "/" do
  "ok"
end

post "/api/slack/cmd" do |env|
  params = env.params.body
  begin
    Bot::DetectHandler.
      detect(params["text"]).
      handle(params["user_id"], params["response_url"])

  rescue Bot::DetectHandler::NoHandlerErr
    halt env, 200, "Invalid command. Use help.```\n#{ENV["SLACK_CMD"]} #{params["text"]}\n```"
  end

  nil
end

add_handler(Middlewares::SlackVerifier.new)
Kemal.config.port = Bot::Env.port
Kemal.run
