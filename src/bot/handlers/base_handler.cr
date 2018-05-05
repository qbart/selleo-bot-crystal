abstract class Bot::BaseHandler
  getter :text

  def initialize(text : String)
    @text = text
  end

  abstract def handle(user_id : String, response_url : String)
end