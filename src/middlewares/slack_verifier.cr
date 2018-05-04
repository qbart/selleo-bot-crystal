module Middlewares
  class SlackVerifier < Kemal::Handler
    exclude ["/"]

    def call(env)
      return call_next(env) if exclude_match?(env)

      params = to_params(env.request.body)
      if valid?(params)
        call_next env
      else
        env.response.status_code = 401
        env.response.print "Unauthorized"
        env.response.close
      end
    end

    private def valid?(params : Hash(String, String))
      params["team_id"] == ENV["SLACK_TEAM_ID"] &&
        params["token"] == ENV["SLACK_TOKEN"] &&
        URI.unescape(params["command"]) == ENV["SLACK_CMD"]
    end

    private def to_params(request_body)
      body = request_body.as(IO).gets_to_end
      body.split("&").reduce(Hash(String, String).new) do |acc, e|
        values = e.split("=")
        acc[values[0]] = values[1]
        acc
      end
    end
  end
end
