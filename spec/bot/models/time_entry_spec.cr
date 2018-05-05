require "./../../spec_helper"
require "./../../../src/bot/models/time_entry"

describe Bot::TimeEntry do
  describe "#to_s" do
    it "returns format acceptable by DM" do
      entry = Bot::TimeEntry.new(
        date: "2018-01-01",
        start_time: "09:00",
        end_time: "11:00",
        details: "hello world"
      )

      entry.to_s.should eq("2018-01-01 09:00 11:00 hello world")
    end
  end

  describe ".parse" do
    it "parses time entry correctly" do
      entry = Bot::TimeEntry.parse("2018-01-01 09:00 11:00 hello world")

      entry.date.should eq "2018-01-01"
      entry.start_time.should eq "09:00"
      entry.end_time.should eq "11:00"
      entry.details.should eq "hello world"
    end
    
    it "parses time entry correctly ignoring whitespaces" do
      entry = Bot::TimeEntry.parse("\t  2018-01-01    09:00   11:00 \t  hello world \t   ")

      entry.date.should eq "2018-01-01"
      entry.start_time.should eq "09:00"
      entry.end_time.should eq "11:00"
      entry.details.should eq "hello world"
    end

    it "raises exception when date is malformed" do
      expect_raises(Bot::TimeEntry::ParseErr, "Couldn't parse time entry: '018-01-01 09:00 11:00 hello world'") do
        Bot::TimeEntry.parse("018-01-01 09:00 11:00 hello world")
      end
    end

    it "raises exception when start_time is malformed" do
      expect_raises(Bot::TimeEntry::ParseErr, "Couldn't parse time entry: '2018-01-01 0900 11:00 hello world'") do
        Bot::TimeEntry.parse("2018-01-01 0900 11:00 hello world")
      end
    end

    it "raises exception when end_time is malformed" do
      expect_raises(Bot::TimeEntry::ParseErr, "Couldn't parse time entry: '2018-01-01 09:00 hello world'") do
        Bot::TimeEntry.parse("2018-01-01 09:00 hello world")
      end
    end

    it "raises exception when details are missing" do
      expect_raises(Bot::TimeEntry::ParseErr, "Couldn't parse time entry: '2018-01-01 09:00 11:00     '") do
        Bot::TimeEntry.parse("2018-01-01 09:00 11:00     ")
      end
    end
  end
end
