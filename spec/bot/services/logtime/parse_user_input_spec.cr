require "./../../../../spec_helper"

describe Bot::Logtime::ParseUserInput do
  describe ".call" do
    it "parses user input correctly" do
      input = "4\n2017-08-31 09:00 14:00 create-1 hello\n2017-08-31 14:00 15:00 working"

      happix, entries = Bot::Logtime::ParseUserInput.call(input)

      happix.should eq 4

      entries[0].date.should eq "2017-08-31"
      entries[0].start_time.should eq "09:00"
      entries[0].end_time.should eq "14:00"
      entries[0].details.should eq "create-1 hello"

      entries[1].date.should eq "2017-08-31"
      entries[1].start_time.should eq "14:00"
      entries[1].end_time.should eq "15:00"
      entries[1].details.should eq "working"
    end

    it "fails when missing happix" do
      input = "\n2017-08-31 09:00 14:00 create-1 hello\n2017-08-31 14:00 15:00 working"

      expect_raises(Bot::Logtime::ParseUserInput::Error, "Unable to parse input:\n#{input}") do
        Bot::Logtime::ParseUserInput.call(input)
      end
    end

    it "fails when time entry is malformed" do
      input = "4\n2017-08-31 09:00 14:00"

      expect_raises(Bot::TimeEntry::ParseErr, "Couldn't parse time entry: '2017-08-31 09:00 14:00'") do
        Bot::Logtime::ParseUserInput.call(input)
      end
    end

    it "fails when time entries are missing" do
      input = "4"

      expect_raises(Bot::Logtime::ParseUserInput::Error, "Unable to parse input:\n#{input}") do
        Bot::Logtime::ParseUserInput.call(input)
      end
    end
  end
end
