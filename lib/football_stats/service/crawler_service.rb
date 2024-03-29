require 'uri'
require 'net/http'
require 'json'

# Crawler class is responsible for fetching the data
class CrawlerService
  AUTHORIZATION_HEADER = 'X-Auth-Token'.freeze

  def initialize(api_base_url, api_key)
    @api_base_url = api_base_url
    @api_key = api_key
  end

  def load_competitions_from_api
    url = create_url('competitions')
    request = create_request(url)
    response = execute_request(url, request)

    if response.nil?
      []
    else
      competitions = JSON.parse(response.read_body, object_class: OpenStruct)
      competitions.competitions
    end
  end

  def load_teams_from_api_for_competitions(competitions)
    teams = []
    competitions&.each do |competition|
      url = create_url("competitions/#{competition.code}/teams")
      request = create_request(url)
      response = execute_request(url, request)

      unless response.nil?
        available_teams_for_competition = JSON.parse(response.read_body, object_class: OpenStruct)
        teams.concat(available_teams_for_competition.teams)
      end
    end
    teams
  end

  def load_matches_from_api_for_team_with_id(team_id)
    url = create_url("teams/#{team_id}/matches")
    request = create_request(url)
    response = execute_request(url, request)

    if response.nil?
      []
    else
      matches = JSON.parse(response.read_body, object_class: OpenStruct)
      matches.matches
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

    if response.is_a?(Net::HTTPTooManyRequests)
      puts('Waiting 60 seconds due to an API requests limitation')
      sleep(60)
      execute_request(url, request)
    else
      puts("An error occurred when executing a request to the url #{url} - #{response.read_body}")
      nil
    end
  end
end
