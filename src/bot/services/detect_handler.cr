class Bot::DetectHandler
  class NoHandlerErr < Exception
  end 

  def self.detect(text)
    if text.starts_with?(Bot::LogTimeHandler::PREFIX)
      Bot::LogTimeHandler.new(text[Bot::LogTimeHandler::PREFIX.size..-1])
    else
      raise NoHandlerErr.new("Invalid command")
    end
  end
end