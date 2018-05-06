require "base64"
require "openssl/hmac"
require "digest/md5"
require "openssl/md5"
require "./../models/time_entry"

class Bot::Dm3
  class Error < Exception
  end

  def create_time_entries(email : String, happix : Int32, time_entries : Array(Bot::TimeEntry))
    body = JSON.build do |json|
      json.object do
        json.field "happix", happix
        json.field "entries", time_entries.map { |entry| entry.to_s }.join("\n")
      end
    end
    headers = build_headers(email, body)
    response = HTTP::Client.post("#{ENV["DM_API_URL"]}/manage/v1/time_entries", headers: headers, body: body)
    handle response do
      log response.inspect
    end
  end

  private def build_headers(email, body)
    HTTP::Headers{
      "Content-type" => "application/json",
      "Authorization" => "DM3 client_id=#{ENV["DM_CLIENT_ID"]};user=#{email};signature=#{signature(body)}"
    }
  end

  private def signature(body)
    checksum = Digest::MD5.hexdigest(body)
    hmac = OpenSSL::HMAC.digest(:sha256, ENV["DM_CLIENT_SECRET"], checksum)
    Base64.strict_encode(hmac)
  end

  private def handle(response)
    case response.status_code
    when 200, 201
      yield
    else
      body = JSON.parse(response.body)
      raise Error.new(body["errors"][0]["detail"].as_s)
    end
  end
end
