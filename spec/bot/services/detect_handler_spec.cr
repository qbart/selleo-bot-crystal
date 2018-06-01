require "../../../spec_helper"


describe Bot::DetectHandler do
  it "returns logtime handler" do
    Bot::DetectHandler.detect("logtime ").class.should eq Bot::LogTimeHandler
  end

  it "fails for invalid handler" do
    expect_raises(Bot::DetectHandler::NoHandlerErr, "Invalid command") do
      Bot::DetectHandler.detect("xxx ")
    end
  end
end
