class JsonClient
  def initialize(@base_url : String)
    @client = HTTP::Client.new(@base_url, tls: true)
  end

  def get(path : String)
    @client.get(path)
  end

  def self.send_post(url, body)
    HTTP::Client.post(url, headers: HTTP::Headers{"Content-type" => "application/json"}, body: body)
  end
end
