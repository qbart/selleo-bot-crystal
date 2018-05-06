class Bot::Logtime::ParseUserInput
  class Error < Exception
  end

  def self.call(input : String) : { Int32, Array(TimeEntry) }
    lines = input.split("\n").map { |line| line.strip }
    if lines.size >= 2
      happix_line = lines.shift
      if happix_line =~ /^\d+$/
        happix = happix_line.to_i
        entries = lines.map { |line| TimeEntry.parse(line) }
        return {happix, entries}
      end
    end

    raise Error.new("Unable to parse input:\n#{input}")
  end
end