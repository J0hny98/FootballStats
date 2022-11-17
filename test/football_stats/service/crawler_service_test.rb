require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../../../lib/football_stats/service/crawler_service'
require_relative './common_steps'

# Crawler service tests class
class CrawlerServiceTest < Minitest::Test
  API_BASE_URL = 'http://api.football-data.org/v4'.freeze
  AUTHORIZATION_HEADER = 'X-Auth-Token'.freeze
  API_KEY = 'api-key'.freeze

  def test_load_competitions_from_api
    # prepare
    crawler_service = CrawlerService.new(API_BASE_URL, API_KEY)

    api_response = File.read('./test/resources/stubs/response/competitions.json')
    stub_request(:get, "#{API_BASE_URL}/competitions/")
      .with(headers: { AUTHORIZATION_HEADER => API_KEY })
      .to_return(body: api_response)

    expected_return = JSON.parse(api_response, object_class: OpenStruct).competitions

    # action
    result = crawler_service.load_competitions_from_api

    # assert
    assert_equal(expected_return, result)
  end

  def test_load_teams_from_api_for_competitions_with_nil_competitions
    # prepare
    crawler_service = CrawlerService.new(API_BASE_URL, API_KEY)

    # action
    result = crawler_service.load_teams_from_api_for_competitions(nil)

    # assert
    assert_equal([], result)
  end

  def test_load_teams_from_api_for_competitions_with_empty_competitions
    # prepare
    crawler_service = CrawlerService.new(API_BASE_URL, API_KEY)

    # action
    result = crawler_service.load_teams_from_api_for_competitions([])

    # assert
    assert_equal([], result)
  end

  def test_load_teams_from_api_for_competitions_with_one_competition
    # prepare
    competitions = CommonSteps.create_dummy_competitions(1)

    crawler_service = CrawlerService.new(API_BASE_URL, API_KEY)

    api_response = File.read('./test/resources/stubs/response/teams_for_competition_1.json')
    stub_request(:get, "#{API_BASE_URL}/competitions/#{competitions[0].code}/teams/")
      .with(headers: { AUTHORIZATION_HEADER => API_KEY })
      .to_return(body: api_response)

    expected_return = JSON.parse(api_response, object_class: OpenStruct).teams

    # action
    result = crawler_service.load_teams_from_api_for_competitions(competitions)

    # assert
    assert_equal(expected_return, result)
  end

  def test_load_teams_from_api_for_competitions_with_multiple_competitions
    # prepare
    competitions = CommonSteps.create_dummy_competitions(2)

    crawler_service = CrawlerService.new(API_BASE_URL, API_KEY)

    api_response1 = File.read('./test/resources/stubs/response/teams_for_competition_1.json')
    stub_request(:get, "#{API_BASE_URL}/competitions/#{competitions[0].code}/teams/")
      .with(headers: { AUTHORIZATION_HEADER => API_KEY })
      .to_return(body: api_response1)

    api_response2 = File.read('./test/resources/stubs/response/teams_for_competition_2.json')
    stub_request(:get, "#{API_BASE_URL}/competitions/#{competitions[1].code}/teams/")
      .with(headers: { AUTHORIZATION_HEADER => API_KEY })
      .to_return(body: api_response2)

    expected_return1 = JSON.parse(api_response1, object_class: OpenStruct).teams
    expected_return2 = JSON.parse(api_response2, object_class: OpenStruct).teams

    combined_expected_return = expected_return1.concat(expected_return2)

    # action
    result = crawler_service.load_teams_from_api_for_competitions(competitions)

    # assert
    assert_equal(combined_expected_return, result)
  end

  def test_load_matches_from_api_for_team_with_id_with
    # prepare
    team_id = 1
    crawler_service = CrawlerService.new(API_BASE_URL, API_KEY)
    
    api_response = File.read('./test/resources/stubs/response/matches.json')
    stub_request(:get, "#{API_BASE_URL}/teams/#{team_id}/matches/")
      .with(headers: { AUTHORIZATION_HEADER => API_KEY })
      .to_return(body: api_response)

    expected_return = JSON.parse(api_response, object_class: OpenStruct).matches
    
    # action
    result = crawler_service.load_matches_from_api_for_team_with_id(team_id)

    # assert
    assert_equal(expected_return, result)
  end
end