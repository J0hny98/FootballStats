require 'minitest/autorun'
require_relative '../../../lib/football_stats/service/main_service'
require_relative '../../../lib/football_stats/entity/competition'
require_relative '../../../lib/football_stats/entity/team'
require_relative '../../../lib/football_stats/entity/match'
require_relative './common_steps'

# Main service tests class
class MainServiceTest < Minitest::Test
  def test_clean_insert_teams_to_database
    # prepare
    competitions = CommonSteps.create_dummy_competitions(5)
    teams = CommonSteps.create_dummy_teams(10)

    crawler_service_mock = MiniTest::Mock.new
    crawler_service_mock.expect(:load_teams_from_api_for_competitions, teams, [competitions])

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:remove_all_matches, nil)
    database_operations_service_mock.expect(:remove_all_teams_competitions, nil)
    database_operations_service_mock.expect(:remove_all_teams, nil)
    database_operations_service_mock.expect(:select_all_competitions, competitions)
    database_operations_service_mock.expect(:insert_batch_teams, nil, [teams])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.clean_insert_teams_to_database

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_put_all_data_to_database
    # prepare
    competitions = CommonSteps.create_dummy_competitions(5)
    teams = CommonSteps.create_dummy_teams(10)

    crawler_service_mock = MiniTest::Mock.new
    crawler_service_mock.expect(:load_competitions_from_api, competitions)
    crawler_service_mock.expect(:load_teams_from_api_for_competitions, teams, [competitions])

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:insert_batch_competitions, nil, [competitions])
    database_operations_service_mock.expect(:select_all_competitions, competitions)
    database_operations_service_mock.expect(:insert_batch_teams, nil, [teams])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.put_all_data_to_database

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_put_competitions_from_api_to_database
    # prepare
    competitions = CommonSteps.create_dummy_competitions(5)

    crawler_service_mock = MiniTest::Mock.new
    crawler_service_mock.expect(:load_competitions_from_api, competitions)

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:insert_batch_competitions, nil, [competitions])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.put_competitions_from_api_to_database

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_put_teams_from_api_to_database
    # prepare
    competitions = CommonSteps.create_dummy_competitions(5)
    teams = CommonSteps.create_dummy_teams(10)

    crawler_service_mock = MiniTest::Mock.new
    crawler_service_mock.expect(:load_teams_from_api_for_competitions, teams, [competitions])

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_all_competitions, competitions)
    database_operations_service_mock.expect(:insert_batch_teams, nil, [teams])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.put_teams_from_api_to_database

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_put_team_matches_from_api_to_database
    # prepare
    teams = CommonSteps.create_dummy_teams(3)
    matches_team1 = CommonSteps.create_dummy_matches(5)
    matches_team2 = CommonSteps.create_dummy_matches(15)
    matches_team3 = CommonSteps.create_dummy_matches(10)

    crawler_service_mock = MiniTest::Mock.new
    crawler_service_mock.expect(:load_matches_from_api_for_team_with_id, matches_team1, [teams[0].team_id])
    crawler_service_mock.expect(:load_matches_from_api_for_team_with_id, matches_team2, [teams[1].team_id])
    crawler_service_mock.expect(:load_matches_from_api_for_team_with_id, matches_team3, [teams[2].team_id])

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_all_teams, teams)
    database_operations_service_mock.expect(:insert_batch_matches, nil, [matches_team1])
    database_operations_service_mock.expect(:insert_batch_matches, nil, [matches_team2])
    database_operations_service_mock.expect(:insert_batch_matches, nil, [matches_team3])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.put_team_matches_from_api_to_database

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_put_team_matches_for_team_with_id_to_database_when_matches_are_nil
    # prepare
    team_id = 1

    crawler_service_mock = MiniTest::Mock.new
    crawler_service_mock.expect(:load_matches_from_api_for_team_with_id, nil, [team_id])

    database_operations_service_mock = MiniTest::Mock.new

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.put_team_matches_for_team_with_id_to_database(team_id)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_put_team_matches_for_team_with_id_to_database_when_matches_are_empty
    # prepare
    team_id = 1

    crawler_service_mock = MiniTest::Mock.new
    crawler_service_mock.expect(:load_matches_from_api_for_team_with_id, [], [team_id])

    database_operations_service_mock = MiniTest::Mock.new

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.put_team_matches_for_team_with_id_to_database(team_id)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_put_team_matches_for_team_with_id_to_database_when_matches_are_not_empty
    # prepare
    team_id = 1
    matches = CommonSteps.create_dummy_matches(10)

    crawler_service_mock = MiniTest::Mock.new
    crawler_service_mock.expect(:load_matches_from_api_for_team_with_id, matches, [team_id])

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:insert_batch_matches, nil, [matches])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.put_team_matches_for_team_with_id_to_database(team_id)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_put_team_matches_for_team_with_name_to_database_with_non_existing_team
    # prepare
    team_name = 'teamName'

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_team_by_name, nil, [team_name])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.put_team_matches_for_team_with_name_to_database(team_name)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_put_team_matches_for_team_with_name_to_database_with_existing_team_with_nil_matches
    # prepare
    team_id = 1
    team_name = 'teamName'
    team = Team.new(team_id, team_name)

    crawler_service_mock = MiniTest::Mock.new
    crawler_service_mock.expect(:load_matches_from_api_for_team_with_id, nil, [team_id])

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_team_by_name, team, [team_name])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.put_team_matches_for_team_with_name_to_database(team_name)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_put_team_matches_for_team_with_name_to_database_with_existing_team_with_empty_matches
    # prepare
    team_id = 1
    team_name = 'teamName'
    team = Team.new(team_id, team_name)

    crawler_service_mock = MiniTest::Mock.new
    crawler_service_mock.expect(:load_matches_from_api_for_team_with_id, [], [team_id])

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_team_by_name, team, [team_name])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.put_team_matches_for_team_with_name_to_database(team_name)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_put_team_matches_for_team_with_name_to_database_with_existing_team_with_not_empty_matches
    # prepare
    team_id = 1
    team_name = 'teamName'
    team = Team.new(team_id, team_name)
    matches = CommonSteps.create_dummy_matches(10)

    crawler_service_mock = MiniTest::Mock.new
    crawler_service_mock.expect(:load_matches_from_api_for_team_with_id, matches, [team_id])

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_team_by_name, team, [team_name])
    database_operations_service_mock.expect(:insert_batch_matches, nil, [matches])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.put_team_matches_for_team_with_name_to_database(team_name)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_select_all_competitions_from_database
    # prepare
    competitions = CommonSteps.create_dummy_competitions(10)

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_all_competitions, competitions)

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_all_competitions_from_database

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_equal(competitions, result)
  end

  def test_select_competition_by_code_with_nil_code
    # prepare
    competition_code = nil

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_competition_by_code, nil, [competition_code])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_competition_by_code(competition_code)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_select_competition_by_code_with_not_nil_code
    # prepare
    competition_code = 'code'
    competitions = CommonSteps.create_dummy_competitions(10)

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_competition_by_code, competitions, [competition_code])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_competition_by_code(competition_code)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_equal(competitions, result)
  end

  def test_select_competition_by_id_with_nil_id
    # prepare
    competition_id = nil

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_competition_by_id, nil, [competition_id])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_competition_by_id(competition_id)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_select_competition_by_id_with_not_nil_id
    # prepare
    competition_id = 'id'
    competitions = CommonSteps.create_dummy_competitions(10)

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_competition_by_id, competitions, [competition_id])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_competition_by_id(competition_id)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_equal(competitions, result)
  end

  def test_select_competition_by_name_with_nil_name
    # prepare
    competition_name = nil

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_competition_by_name, nil, [competition_name])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_competition_by_name(competition_name)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_select_competition_by_name_with_not_nil_name
    # prepare
    competition_name = 'name'
    competitions = CommonSteps.create_dummy_competitions(10)

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_competition_by_name, competitions, [competition_name])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_competition_by_name(competition_name)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_equal(competitions, result)
  end

  def test_select_all_teams_from_database
    # prepare
    teams = CommonSteps.create_dummy_teams(10)

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_all_teams, teams)

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_all_teams_from_database

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_equal(teams, result)
  end

  def test_select_team_by_id_with_nil_id
    # prepare
    team_id = nil

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_team_by_id, nil, [team_id])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_team_by_id(team_id)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_select_team_by_id_with_not_nil_id
    # prepare
    team_id = 'id'
    teams = CommonSteps.create_dummy_teams(10)

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_team_by_id, teams, [team_id])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_team_by_id(team_id)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_equal(teams, result)
  end

  def test_select_team_by_name_with_nil_name
    # prepare
    team_name = nil

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_team_by_name, nil, [team_name])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_team_by_name(team_name)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_select_team_by_name_with_not_nil_name
    # prepare
    team_name = 'name'
    teams = CommonSteps.create_dummy_teams(10)

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_team_by_name, teams, [team_name])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_team_by_name(team_name)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_equal(teams, result)
  end

  def test_select_teams_in_competition_with_id_with_nil_id
    # prepare
    competition_id = nil

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_teams_in_competition_with_id, nil, [competition_id])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_teams_in_competition_with_id(competition_id)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_select_teams_in_competition_with_id_with_not_nil_id
    # prepare
    competition_id = 1
    teams = CommonSteps.create_dummy_teams(10)

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_teams_in_competition_with_id, teams, [competition_id])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_teams_in_competition_with_id(competition_id)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_equal(teams, result)
  end

  def test_select_teams_in_competition_with_name_with_not_found_competition
    # prepare
    competition_name = 'name'

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_competition_by_name, nil, [competition_name])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_teams_in_competition_with_name(competition_name)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_select_teams_in_competition_with_name_with_found_competition
    # prepare
    competition_name = 'name'
    competition = CommonSteps.create_dummy_competitions(1)[0]
    teams = CommonSteps.create_dummy_teams(10)

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_competition_by_name, competition, [competition_name])
    database_operations_service_mock.expect(:select_teams_in_competition_with_id, teams, [competition.competition_id])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_teams_in_competition_with_name(competition_name)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_equal(teams, result)
  end

  def test_select_select_matches_for_team_with_id_with_nil_id
    # prepare
    team_id = nil

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_matches_for_team_with_id, nil, [team_id])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_matches_for_team_with_id(team_id)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_select_matches_for_team_with_id_with_not_nil_id
    # prepare
    team_id = 1
    matches = CommonSteps.create_dummy_matches(10)

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_matches_for_team_with_id, matches, [team_id])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_matches_for_team_with_id(team_id)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_equal(matches, result)
  end

  def test_select_matches_for_team_with_name_with_not_found_team
    # prepare
    team_name = 'name'

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_team_by_name, nil, [team_name])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_matches_for_team_with_name(team_name)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_equal([], result)
  end

  def test_select_matches_for_team_with_name_with_found_team
    # prepare
    team_id = 1
    team_name = 'name'
    team = Team.new(team_id, team_name)
    matches = CommonSteps.create_dummy_matches(10)

    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:select_team_by_name, team, [team_name])
    database_operations_service_mock.expect(:select_matches_for_team_with_id, matches, [team_id])

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.select_matches_for_team_with_name(team_name)

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_equal(matches, result)
  end

  def test_remove_all_data_from_database
    # prepare
    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:remove_all_matches, nil)
    database_operations_service_mock.expect(:remove_all_teams_competitions, nil)
    database_operations_service_mock.expect(:remove_all_teams, nil)
    database_operations_service_mock.expect(:remove_all_competitions, nil)

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.remove_all_data_from_database

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end

  def test_remove_all_teams_from_database
    # prepare
    crawler_service_mock = MiniTest::Mock.new

    database_operations_service_mock = MiniTest::Mock.new
    database_operations_service_mock.expect(:remove_all_matches, nil)
    database_operations_service_mock.expect(:remove_all_teams_competitions, nil)
    database_operations_service_mock.expect(:remove_all_teams, nil)

    main_service = MainService.new(crawler_service_mock, database_operations_service_mock)

    # action
    result = main_service.remove_all_teams_from_database

    # assert
    crawler_service_mock.verify
    database_operations_service_mock.verify

    assert_nil(result)
  end
end
