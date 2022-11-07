require 'uri'
require 'net/http'
require 'json'
require_relative './competition'
require_relative './database_operations'

# Crawler class is responsible for fetching the data
class Crawler
  API_BASE_URL = 'http://api.football-data.org/v4'.freeze
  AUTHORIZATION_HEADER = 'X-Auth-Token'.freeze
  # AUTHORIZATION_TOKEN = '7fc818b7d73e47d4babe4a58bb25ea81'.freeze

  def initialize(api_key)
    puts 'Initializing crawler'
    @api_base_url = API_BASE_URL
    @api_key = api_key
    @database_operations = DatabaseOperations.new('football_stats', 'admin', 'admin')
  end

  def put_competitions_to_database
    puts 'Updating competitions'

    url = create_url('competitions')
    request = create_request(url)
    response = execute_request(url, request)

    available_commpetitions = JSON.parse(response.read_body, object_class: OpenStruct)

    @database_operations.insert_batch_competitions(available_commpetitions.competitions)
    puts 'Competitions updated'
  end

  def put_teams_to_database
    puts 'Updating teams'
    available_commpetitions = @database_operations.get_all_available_competitions
    available_commpetitions.each do |competition|
      url = create_url("competitions/#{competition.code}/teams")
      request = create_request(url)
      response = execute_request(url, request)

      available_teams = JSON.parse(response.read_body, object_class: OpenStruct)
      @database_operations.insert_batch_teams(available_teams.teams)
    end

    puts 'Teams Updated'
  end

  def get_teams_matches(team_id)
    puts "Getting matches for team #{team_id}"
    url_string = "#{@api_base_url}/teams/#{team_id}/matches"
    url = URI(url_string)
  end

  private

  def create_url(uri)
    url_string = "#{@api_base_url}/#{uri}/"
    URI.parse(url_string)
  end

  def create_request(url)
    request = Net::HTTP::Get.new(url)
    request[AUTHORIZATION_HEADER] = @api_key
    request
  end

  def execute_request(url, request)
    response = Net::HTTP.start(url.hostname, url.port) { |http|
      http.request(request)
    }

    return response if response.is_a?(Net::HTTPSuccess)

    puts('Waiting 60 seconds due to an API requests limitation')
    sleep(60)
    execute_request(url, request)
  end
end
