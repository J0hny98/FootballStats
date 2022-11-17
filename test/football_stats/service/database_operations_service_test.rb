require 'minitest/autorun'
require 'pg'
require_relative '../../../lib/football_stats/service/database_operations_service'
require_relative '../../../lib/football_stats/entity/competition'
require_relative '../../../lib/football_stats/entity/team'
require_relative '../../../lib/football_stats/entity/match'
require_relative './common_steps'

# Main service tests class
class DatabaseOperationsServiceTest < Minitest::Test
  def test_insert_batch_competitions_when_competitions_are_nil
    # prepare
    competitions = nil

    database_operations_dao_mock = MiniTest::Mock.new

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_competitions(competitions)

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_competitions_when_competitions_are_empty
    # prepare
    competitions = []

    database_operations_dao_mock = MiniTest::Mock.new

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_competitions(competitions)

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_competitions_when_competitions_are_not_empty
    # prepare
    competitions = CommonSteps.create_dummy_competitions(3)

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:insert_competition, nil, [competitions[0]])
    database_operations_dao_mock.expect(:insert_competition, nil, [competitions[1]])
    database_operations_dao_mock.expect(:insert_competition, nil, [competitions[2]])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_competitions(competitions)

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_matches_when_matches_are_nil
    # prepare
    matches = nil

    database_operations_dao_mock = MiniTest::Mock.new

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_matches(matches)

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_matches_when_matches_are_empty
    # prepare
    matches = []

    database_operations_dao_mock = MiniTest::Mock.new

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_matches(matches)

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_matches_when_home_team_not_in_database
    # prepare
    home_team_id = 1
    home_team_from_api = OpenStruct.new(id: home_team_id)

    away_team_id = 2
    away_team_name = 'AwayName'
    away_team_from_api = OpenStruct.new(id: away_team_id)
    away_team = Team.new(away_team_id, away_team_name)

    match = OpenStruct.new(homeTeam: home_team_from_api, awayTeam: away_team_from_api)

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_team_by_id, nil, [home_team_id])
    database_operations_dao_mock.expect(:select_team_by_id, away_team, [away_team_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_matches([match])

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_matches_when_away_team_not_in_database
    # prepare
    home_team_id = 1
    home_team_name = 'HomeName'
    home_team_from_api = OpenStruct.new(id: home_team_id)
    home_team = Team.new(home_team_id, home_team_name)

    away_team_id = 2
    away_team_from_api = OpenStruct.new(id: away_team_id)

    match = OpenStruct.new(homeTeam: home_team_from_api, awayTeam: away_team_from_api)

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_team_by_id, home_team, [home_team_id])
    database_operations_dao_mock.expect(:select_team_by_id, nil, [away_team_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_matches([match])

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_matches_when_both_teams_not_in_database
    # prepare
    home_team_id = 1
    home_team_from_api = OpenStruct.new(id: home_team_id)

    away_team_id = 2
    away_team_from_api = OpenStruct.new(id: away_team_id)

    match = OpenStruct.new(homeTeam: home_team_from_api, awayTeam: away_team_from_api)

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_team_by_id, nil, [home_team_id])
    database_operations_dao_mock.expect(:select_team_by_id, nil, [away_team_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_matches([match])

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_matches_when_teams_are_in_database_with_one_match
    # prepare
    home_team_id = 1
    home_team_name = 'HomeName'
    home_team_from_api = OpenStruct.new(id: home_team_id)
    home_team = Team.new(home_team_id, home_team_name)

    away_team_id = 2
    away_team_name = 'AwayName'
    away_team_from_api = OpenStruct.new(id: away_team_id)
    away_team = Team.new(away_team_id, away_team_name)

    match = OpenStruct.new(homeTeam: home_team_from_api, awayTeam: away_team_from_api)

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_team_by_id, home_team, [home_team_id])
    database_operations_dao_mock.expect(:select_team_by_id, away_team, [away_team_id])
    database_operations_dao_mock.expect(:insert_team_match, nil, [match])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_matches([match])

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_matches_when_teams_are_in_database_with_multiple_matches
    # prepare
    home_team_id = 1
    home_team_name = 'HomeName'
    home_team_from_api = OpenStruct.new(id: home_team_id)
    home_team = Team.new(home_team_id, home_team_name)

    away_team_id = 2
    away_team_name = 'AwayName'
    away_team_from_api = OpenStruct.new(id: away_team_id)
    away_team = Team.new(away_team_id, away_team_name)

    match1 = OpenStruct.new(homeTeam: home_team_from_api, awayTeam: away_team_from_api)
    match2 = OpenStruct.new(homeTeam: home_team_from_api, awayTeam: away_team_from_api)
    match3 = OpenStruct.new(homeTeam: home_team_from_api, awayTeam: away_team_from_api)

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_team_by_id, home_team, [home_team_id])
    database_operations_dao_mock.expect(:select_team_by_id, away_team, [away_team_id])
    database_operations_dao_mock.expect(:select_team_by_id, nil, [home_team_id])
    database_operations_dao_mock.expect(:select_team_by_id, nil, [away_team_id])
    database_operations_dao_mock.expect(:select_team_by_id, home_team, [home_team_id])
    database_operations_dao_mock.expect(:select_team_by_id, away_team, [away_team_id])
    database_operations_dao_mock.expect(:insert_team_match, nil, [match1])
    database_operations_dao_mock.expect(:insert_team_match, nil, [match3])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_matches([match1, match2, match3])

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_teams_when_teams_are_nil
    # prepare
    teams = nil

    database_operations_dao_mock = MiniTest::Mock.new

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_teams(teams)

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_teams_when_teams_are_empty
    # prepare
    teams = []

    database_operations_dao_mock = MiniTest::Mock.new

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_teams(teams)

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_teams_with_one_team_with_running_competitions_nil
    # prepare
    team_id = 1
    team = OpenStruct.new(id: team_id)

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:insert_team, nil, [team])
    database_operations_dao_mock.expect(:remove_team_competitions_for_team_with_id, nil, [team_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_teams([team])

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_teams_with_one_team_with_running_competitions_empty
    # prepare
    team_id = 1
    team = OpenStruct.new(id: team_id, runningCompetitions: [])

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:insert_team, nil, [team])
    database_operations_dao_mock.expect(:remove_team_competitions_for_team_with_id, nil, [team_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_teams([team])

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_teams_with_one_team_with_running_competitions_not_empty_not_found_competition
    # prepare
    competition_id = 1
    competition = OpenStruct.new(id: competition_id)

    team_id = 2
    team_name = 'name'
    team_from_api = OpenStruct.new(id: team_id, runningCompetitions: [competition])
    team = Team.new(team_id, team_name)

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:insert_team, nil, [team_from_api])
    database_operations_dao_mock.expect(:remove_team_competitions_for_team_with_id, nil, [team_id])
    database_operations_dao_mock.expect(:select_competition_by_id, nil, [competition_id])
    database_operations_dao_mock.expect(:select_team_by_id, team, [team_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_teams([team_from_api])

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_teams_with_one_team_with_running_competitions_not_empty_not_found_team
    # prepare
    competition = CommonSteps.create_dummy_competitions(1)[0]
    competition_id = competition.competition_id
    competition_from_api = OpenStruct.new(id: competition_id)

    team_id = 2
    team_from_api = OpenStruct.new(id: team_id, runningCompetitions: [competition_from_api])

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:insert_team, nil, [team_from_api])
    database_operations_dao_mock.expect(:remove_team_competitions_for_team_with_id, nil, [team_id])
    database_operations_dao_mock.expect(:select_competition_by_id, competition, [competition_id])
    database_operations_dao_mock.expect(:select_team_by_id, nil, [team_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_teams([team_from_api])

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_teams_with_one_team_with_running_competitions_not_empty_not_found_team_and_competition
    # prepare
    competition = CommonSteps.create_dummy_competitions(1)[0]
    competition_id = competition.competition_id
    competition_from_api = OpenStruct.new(id: competition_id)

    team_id = 2
    team_from_api = OpenStruct.new(id: team_id, runningCompetitions: [competition_from_api])

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:insert_team, nil, [team_from_api])
    database_operations_dao_mock.expect(:remove_team_competitions_for_team_with_id, nil, [team_id])
    database_operations_dao_mock.expect(:select_competition_by_id, nil, [competition_id])
    database_operations_dao_mock.expect(:select_team_by_id, nil, [team_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_teams([team_from_api])

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_teams_with_one_team_with_multiple_running_competitions
    # prepare
    competitions = CommonSteps.create_dummy_competitions(3)
    competition1 = competitions[0]
    competition2 = competitions[1]
    competition3 = competitions[2]

    competition_from_api1 = OpenStruct.new(id: competition1.competition_id)
    competition_from_api2 = OpenStruct.new(id: competition2.competition_id)
    competition_from_api3 = OpenStruct.new(id: competition3.competition_id)

    team_id = 2
    team_name = 'teamName'
    team = Team.new(team_id, team_name)
    team_from_api = OpenStruct.new(id: team_id,
                                   runningCompetitions: [competition_from_api1,
                                                         competition_from_api2, competition_from_api3])

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:insert_team, nil, [team_from_api])
    database_operations_dao_mock.expect(:remove_team_competitions_for_team_with_id, nil, [team_id])
    database_operations_dao_mock.expect(:select_competition_by_id, competition_from_api1, [competition1.competition_id])
    database_operations_dao_mock.expect(:select_competition_by_id, nil, [competition2.competition_id])
    database_operations_dao_mock.expect(:select_competition_by_id, competition_from_api3, [competition3.competition_id])
    database_operations_dao_mock.expect(:select_team_by_id, team, [team_id])
    database_operations_dao_mock.expect(:select_team_by_id, team, [team_id])
    database_operations_dao_mock.expect(:select_team_by_id, team, [team_id])
    database_operations_dao_mock.expect(:insert_team_competition, nil, [team_id, competition1.competition_id])
    database_operations_dao_mock.expect(:insert_team_competition, nil, [team_id, competition3.competition_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_teams([team_from_api])

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_insert_batch_teams_with_multiple_teams_with_multiple_running_competitions
    # prepare
    competitions = CommonSteps.create_dummy_competitions(6)
    competition1 = competitions[0]
    competition2 = competitions[1]
    competition3 = competitions[2]
    competition4 = competitions[3]
    competition5 = competitions[4]
    competition6 = competitions[5]

    competition_from_api1 = OpenStruct.new(id: competition1.competition_id)
    competition_from_api2 = OpenStruct.new(id: competition2.competition_id)
    competition_from_api3 = OpenStruct.new(id: competition3.competition_id)
    competition_from_api4 = OpenStruct.new(id: competition4.competition_id)
    competition_from_api5 = OpenStruct.new(id: competition5.competition_id)
    competition_from_api6 = OpenStruct.new(id: competition6.competition_id)

    team_id1 = 1
    team_name1 = 'teamName1'
    team1 = Team.new(team_id1, team_name1)
    team_from_api1 = OpenStruct.new(id: team_id1,
                                    runningCompetitions: [competition_from_api1,
                                                          competition_from_api2, competition_from_api3])

    team_id2 = 2
    team_name2 = 'teamName2'
    team2 = Team.new(team_id2, team_name2)
    team_from_api2 = OpenStruct.new(id: team_id2,
                                    runningCompetitions: [competition_from_api4,
                                                          competition_from_api5, competition_from_api6])

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:insert_team, nil, [team_from_api1])
    database_operations_dao_mock.expect(:insert_team, nil, [team_from_api2])
    database_operations_dao_mock.expect(:remove_team_competitions_for_team_with_id, nil, [team_id1])
    database_operations_dao_mock.expect(:remove_team_competitions_for_team_with_id, nil, [team_id2])
    database_operations_dao_mock.expect(:select_competition_by_id, competition_from_api1, [competition1.competition_id])
    database_operations_dao_mock.expect(:select_competition_by_id, nil, [competition2.competition_id])
    database_operations_dao_mock.expect(:select_competition_by_id, competition_from_api3, [competition3.competition_id])
    database_operations_dao_mock.expect(:select_competition_by_id, competition_from_api4, [competition4.competition_id])
    database_operations_dao_mock.expect(:select_competition_by_id, nil, [competition5.competition_id])
    database_operations_dao_mock.expect(:select_competition_by_id, competition_from_api6, [competition6.competition_id])
    database_operations_dao_mock.expect(:select_team_by_id, team1, [team_id1])
    database_operations_dao_mock.expect(:select_team_by_id, team1, [team_id1])
    database_operations_dao_mock.expect(:select_team_by_id, team1, [team_id1])
    database_operations_dao_mock.expect(:select_team_by_id, team2, [team_id2])
    database_operations_dao_mock.expect(:select_team_by_id, team2, [team_id2])
    database_operations_dao_mock.expect(:select_team_by_id, team2, [team_id2])
    database_operations_dao_mock.expect(:insert_team_competition, nil, [team_id1, competition1.competition_id])
    database_operations_dao_mock.expect(:insert_team_competition, nil, [team_id1, competition3.competition_id])
    database_operations_dao_mock.expect(:insert_team_competition, nil, [team_id2, competition4.competition_id])
    database_operations_dao_mock.expect(:insert_team_competition, nil, [team_id2, competition6.competition_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.insert_batch_teams([team_from_api1, team_from_api2])

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_select_all_competitions
    # prepare
    competitions = CommonSteps.create_dummy_competitions(10)

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_all_competitions, competitions)

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_all_competitions

    # assert
    database_operations_dao_mock.verify

    assert_equal(competitions, result)
  end

  def test_select_all_teams
    # prepare
    teams = CommonSteps.create_dummy_teams(10)

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_all_teams, teams)

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_all_teams

    # assert
    database_operations_dao_mock.verify

    assert_equal(teams, result)
  end

  def test_select_competition_by_id_with_not_found_competition
    # prepare
    competition_id = 1

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_competition_by_id, nil, [competition_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_competition_by_id(competition_id)

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_select_competition_by_id_with_found_competition
    # prepare
    competition = CommonSteps.create_dummy_competitions(1)[0]

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_competition_by_id, competition, [competition.competition_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_competition_by_id(competition.competition_id)

    # assert
    database_operations_dao_mock.verify

    assert_equal(competition, result)
  end

  def test_select_team_by_id_with_not_found_team
    # prepare
    team_id = 1

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_team_by_id, nil, [team_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_team_by_id(team_id)

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_select_team_by_id_with_found_team
    # prepare
    team = CommonSteps.create_dummy_teams(1)[0]

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_team_by_id, team, [team.team_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_team_by_id(team.team_id)

    # assert
    database_operations_dao_mock.verify

    assert_equal(team, result)
  end

  def test_select_competition_by_code_with_not_found_competition
    # prepare
    competition_code = 'code'

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_competition_by_code, nil, [competition_code])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_competition_by_code(competition_code)

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_select_competition_by_code_with_found_competition
    # prepare
    competition = CommonSteps.create_dummy_competitions(1)[0]

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_competition_by_code, competition, [competition.code])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_competition_by_code(competition.code)

    # assert
    database_operations_dao_mock.verify

    assert_equal(competition, result)
  end

  def test_select_competition_by_name_with_not_found_competition
    # prepare
    competition_name = 'name'

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_competition_by_name, nil, [competition_name])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_competition_by_name(competition_name)

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_select_competition_by_name_with_found_competition
    # prepare
    competition = CommonSteps.create_dummy_competitions(1)[0]

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_competition_by_name, competition, [competition.name])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_competition_by_name(competition.name)

    # assert
    database_operations_dao_mock.verify

    assert_equal(competition, result)
  end

  def test_select_team_by_name_with_not_found_team
    # prepare
    team_name = 'name'

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_team_by_name, nil, [team_name])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_team_by_name(team_name)

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_select_team_by_name_with_found_team
    # prepare
    team = CommonSteps.create_dummy_teams(1)[0]

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_team_by_name, team, [team.name])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_team_by_name(team.name)

    # assert
    database_operations_dao_mock.verify

    assert_equal(team, result)
  end

  def test_select_teams_in_competition_with_id_with_found_teams_nil
    # prepare
    competition_id = 1

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_teams_in_competition_with_id, nil, [competition_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_teams_in_competition_with_id(competition_id)

    # assert
    database_operations_dao_mock.verify

    assert_equal([], result)
  end

  def test_select_teams_in_competition_with_id_with_found_teams_empty_list
    # prepare
    competition_id = 1

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_teams_in_competition_with_id, [], [competition_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_teams_in_competition_with_id(competition_id)

    # assert
    database_operations_dao_mock.verify

    assert_equal([], result)
  end

  def test_select_teams_in_competition_with_id_with_found_teams_not_empty_list
    # prepare
    competition_id = 1
    teams = CommonSteps.create_dummy_teams(10)

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_teams_in_competition_with_id, teams, [competition_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_teams_in_competition_with_id(competition_id)

    # assert
    database_operations_dao_mock.verify

    assert_equal(teams, result)
  end

  def test_select_matches_for_team_with_id_with_found_matches_nil
    # prepare
    team_id = 1

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_matches_for_team_with_id, nil, [team_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_matches_for_team_with_id(team_id)

    # assert
    database_operations_dao_mock.verify

    assert_equal([], result)
  end

  def test_select_matches_for_team_with_id_with_found_matches_empty_list
    # prepare
    team_id = 1

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_matches_for_team_with_id, [], [team_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_matches_for_team_with_id(team_id)

    # assert
    database_operations_dao_mock.verify

    assert_equal([], result)
  end

  def test_select_matches_for_team_with_id_with_found_matches_not_empty_list
    # prepare
    team_id = 1
    matches = CommonSteps.create_dummy_matches(10)

    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:select_matches_for_team_with_id, matches, [team_id])

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.select_matches_for_team_with_id(team_id)

    # assert
    database_operations_dao_mock.verify

    assert_equal(matches, result)
  end

  def test_remove_all_matches
    # prepare
    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:remove_all_matches, nil)

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.remove_all_matches

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_remove_all_teams_competitions
    # prepare
    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:remove_all_teams_competitions, nil)

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.remove_all_teams_competitions

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_remove_all_teams
    # prepare
    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:remove_all_teams, nil)

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.remove_all_teams

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end

  def test_remove_all_competitions
    # prepare
    database_operations_dao_mock = MiniTest::Mock.new
    database_operations_dao_mock.expect(:remove_all_competitions, nil)

    database_operations_service = DatabaseOperationsService.new(database_operations_dao_mock)

    # action
    result = database_operations_service.remove_all_competitions

    # assert
    database_operations_dao_mock.verify

    assert_nil(result)
  end
end
