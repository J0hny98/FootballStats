require 'uri'
require 'net/http'
require 'json'

# Crawler class is responsible for fetching the data
class Crawler
  API_BASE_URL = 'http://api.football-data.org/v4'.freeze

  def initialize(api_key)
    puts 'Initializing crawler'
    @api_base_url = API_BASE_URL
    @api_key = api_key
  end

  def get_competitions
    puts 'Getting all available competitions'
  end

  def get_teams_matches(team_id)
    puts "Getting matches for team #{team_id}"
    url_string = "#{@api_base_url}/teams/#{team_id}/matches"
    url = URI(url_string)
  end

  def test(message)
    puts message
  end
end
