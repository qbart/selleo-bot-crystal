struct Bot::TimeEntry
  class ParseErr < Exception
  end

  getter date, start_time, end_time, details

  REGEX = /
    \A
    \s*                           # allow spacing
    (?:
      (?<date>\d{4}-\d{2}-\d{2})    # yyyy-mm-dd
      \s+                           # at least 1 space required
    )?                            # date is optional
    (?<start_time>\d{2}:\d{2})    # hh:mm
    \s+                           # at least 1 space required
    (?<end_time>\d{2}:\d{2})      # hh:mm
    \s+                           # at least 1 space required
    (?<details>\S{1}.*?)          # must start with non-space character
    (?:\s*)                       # allow spacing
    \z
  /x

  def initialize(@date : String, @start_time : String, @end_time : String, @details : String)
  end

  def self.parse(str : String) : TimeEntry
    match_data = REGEX.match(str)
    if match_data
      TimeEntry.new(
        date: match_data["date"]? || Time.now.date.to_s("%F"),
        start_time: match_data["start_time"],
        end_time: match_data["end_time"],
        details: match_data["details"]
      )
    else
      raise ParseErr.new("Couldn't parse time entry: '#{str}'")
    end
  end

  def to_s
    "#{date} #{start_time} #{end_time} #{details}"
  end
end
