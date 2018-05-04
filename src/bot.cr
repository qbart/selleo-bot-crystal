require "kemal"
require "dotenv"
require "./bot/env"
require "./middlewares/slack_verifier"

Bot::Env.load

get "/" do
  "ok"
end

post "/api/slack/cmd" do |env|
  halt env, status_code: 500
end

add_handler(Middlewares::SlackVerifier.new)
Kemal.config.port = Bot::Env.port
Kemal.run
