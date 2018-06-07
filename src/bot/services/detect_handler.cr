class Bot::DetectHandler
  class NoHandlerErr < Exception
  end

  def self.detect(text)
    if text.starts_with?(Bot::LogtimeHandler::PREFIX)
      Bot::LogtimeHandler.new(text[Bot::LogtimeHandler::PREFIX.size..-1])
    elsif text.starts_with?(Bot::HelpHandler::PREFIX)
      Bot::HelpHandler.new("")
    else
      raise NoHandlerErr.new("Invalid command")
    end
  end
end
