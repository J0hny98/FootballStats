require 'uri'
require 'net/http'
require 'json'
require_relative '../entity/competition'
require_relative './database_operations_service'

# Crawler class is responsible for fetching the data
class CrawlerService
  API_BASE_URL = 'http://api.football-data.org/v4'.freeze
  AUTHORIZATION_HEADER = 'X-Auth-Token'.freeze
  # AUTHORIZATION_TOKEN = '7fc818b7d73e47d4babe4a58bb25ea81'.freeze

  def initialize(api_key)
    puts 'Initializing crawler'
    @api_base_url = API_BASE_URL
    @api_key = api_key
    @database_operations_service = DatabaseOperationsService.new('football_stats', 'admin', 'admin')
  end

  def put_competitions_to_database
    url = create_url('competitions')
    request = create_request(url)
    response = execute_request(url, request)

    available_commpetitions = JSON.parse(response.read_body, object_class: OpenStruct)

    @database_operations_service.insert_batch_competitions(available_commpetitions.competitions)
  end

  def put_teams_to_database
    available_commpetitions = @database_operations_service.get_all_available_competitions
    available_commpetitions.each do |competition|
      url = create_url("competitions/#{competition.code}/teams")
      request = create_request(url)
      response = execute_request(url, request)

      available_teams = JSON.parse(response.read_body, object_class: OpenStruct)
      @database_operations_service.insert_batch_teams(available_teams.teams)
    end
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
    response = Net::HTTP.start(url.hostname, url.port) do |http|
      http.request(request)
    end

    return response if response.is_a?(Net::HTTPSuccess)

    puts('Waiting 60 seconds due to an API requests limitation')
    sleep(60)
    execute_request(url, request)
  end
end