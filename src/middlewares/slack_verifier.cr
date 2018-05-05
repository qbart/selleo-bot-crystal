module Middlewares
  class SlackVerifier < Kemal::Handler
    exclude ["/"]

    def call(env)
      return call_next(env) if exclude_match?(env)

      params = consume_params(env.request)
      if valid?(params)
        passed_params = HTTP::Params.build do |builder|
          builder.add "text", params["text"]
          builder.add "user_id", params["user_id"]
          builder.add "response_url", params["response_url"]
        end
        env.request.body = passed_params
        call_next env
      else
        env.response.status_code = 401
        env.response.print "Unauthorized"
        env.response.close
      end
    end

    private def valid?(params)
      params["team_id"] == ENV["SLACK_TEAM_ID"] &&
        params["token"] == ENV["SLACK_TOKEN"] &&
        URI.unescape(params["command"]) == ENV["SLACK_CMD"]
    end

    private def consume_params(request)
      parser = Kemal::ParamParser.new(request)
      parser.not_nil!.body
    end
  end
end
