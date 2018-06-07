require "../../../spec_helper"


describe Bot::DetectHandler do
  it "returns help handler" do
    Bot::DetectHandler.detect("help").class.should eq Bot::HelpHandler
  end

  it "returns logtime handler" do
    Bot::DetectHandler.detect("logtime ").class.should eq Bot::LogtimeHandler
  end

  it "fails for invalid handler" do
    expect_raises(Bot::DetectHandler::NoHandlerErr, "Invalid command") do
      Bot::DetectHandler.detect("xxx ")
    end
  end
end
