module Bot
  class Env
    def self.current
      ENV.fetch("KEMAL_ENV", "development")
    end

    def self.load
      if current != "production"
        Dotenv.load
        Dotenv.load(".env." + current)
        Dotenv.load(".env." + current + ".local")
      end
    end

    def self.port
      case current
      when "production"
        ENV["PORT"].to_i
      when "test"
        3099
      else
        3000
      end
    end
  end
end