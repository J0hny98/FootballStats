# Config class
class Config
  DATABASE_NAME = 'football_stats'.freeze
  DATABASE_USER = 'admin'.freeze
  DATABASE_PASSWORD = 'admin'.freeze
  API_BASE_URL = 'http://api.football-data.org/v4'.freeze
  API_KEY = 'api-key'.freeze

  class << self
    def api_base_url
      API_BASE_URL
    end

    def api_key
      API_KEY
    end

    def database_name
      DATABASE_NAME
    end

    def database_user
      DATABASE_USER
    end

    def database_password
      DATABASE_PASSWORD
    end
  end
end
