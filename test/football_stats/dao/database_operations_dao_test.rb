require 'pg'
require 'ostruct'
require 'minitest/autorun'
require_relative '../../../lib/football_stats/dao/database_operations_dao'
require_relative '../../../lib/football_stats/entity/competition'
require_relative '../../../lib/football_stats/entity/team'
require_relative '../../../lib/football_stats/entity/match'

# Database operations dao test suite
class DatabaseOperationsDaoTest < Minitest::Test
  TEST_DATABSE_NAME = 'football_stats_test'.freeze
  TEST_DATABASE_USER = 'admin'.freeze
  TEST_DATABASE_PASSWORD = 'admin'.freeze

  def setup
    create_database
  end

  def teardown
    drop_database
  end

  def test_insert_competition_when_competition_is_nil
    # prepare
    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    # action
    result = database_operations_dao.insert_competition(nil)

    # assert
    assert_nil(result)
    assert_equal([], database_operations_dao.select_all_competitions)
  end

  def test_insert_competition_when_competition_is_not_nil
    # prepare
    competition_id = 1
    competition_name = 'name'
    competition_code = 'code'
    competition_type = 'type'
    competition_number_of_available_seasons = 5

    competition = OpenStruct.new(id: competition_id, name: competition_name, code: competition_code,
                                 type: competition_type,
                                 numberOfAvailableSeasons: competition_number_of_available_seasons)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    expected_found_competition = Competition.new(competition_id.to_s, competition_name, competition_code,
                                                 competition_type, competition_number_of_available_seasons.to_s)

    # action
    result = database_operations_dao.insert_competition(competition)

    # assert
    assert_nil(result)
    found_competitions = database_operations_dao.select_all_competitions
    assert_equal(1, found_competitions.size)
    assert_equal(expected_found_competition, found_competitions[0])
  end

  def test_insert_competition_when_competition_already_exists
    # prepare
    competition_id = 1
    competition_name = 'name'
    competition_code = 'code'
    competition_type = 'type'
    competition_number_of_available_seasons = 5

    competition = OpenStruct.new(id: competition_id, name: competition_name, code: competition_code,
                                 type: competition_type,
                                 numberOfAvailableSeasons: competition_number_of_available_seasons)

    competition_name_updated = 'nameUpdated'
    competition_code_updated = 'codeUpdated'
    competition_type_updated = 'typeUpdated'
    competition_number_of_available_seasons_updated = 15

    competition_updated = OpenStruct.new(id: competition_id, name: competition_name_updated,
                                         code: competition_code_updated, type: competition_type_updated,
                                         numberOfAvailableSeasons: competition_number_of_available_seasons_updated)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    expected_found_competition = Competition.new(competition_id.to_s, competition_name_updated,
                                                 competition_code_updated,
                                                 competition_type_updated,
                                                 competition_number_of_available_seasons_updated.to_s)

    database_operations_dao.insert_competition(competition)

    # action
    result = database_operations_dao.insert_competition(competition_updated)

    # assert
    assert_nil(result)
    found_competitions = database_operations_dao.select_all_competitions
    assert_equal(1, found_competitions.size)
    assert_equal(expected_found_competition, found_competitions[0])
  end

  def test_select_all_competitions_with_empty_competitions
    # prepare
    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    # action
    result = database_operations_dao.select_all_competitions

    # assert
    assert_equal(0, result.size)
    assert_equal([], result)
  end

  def test_select_all_competitions_with_multiple_competitions
    # prepare
    competition_id1 = 1
    competition_name1 = 'name1'
    competition_code1 = 'code1'
    competition_type1 = 'type1'
    competition_number_of_available_seasons1 = 5

    competition1 = OpenStruct.new(id: competition_id1, name: competition_name1, code: competition_code1,
                                  type: competition_type1,
                                  numberOfAvailableSeasons: competition_number_of_available_seasons1)

    competition_id2 = 2
    competition_name2 = 'name2'
    competition_code2 = 'code2'
    competition_type2 = 'type2'
    competition_number_of_available_seasons2 = 15

    competition2 = OpenStruct.new(id: competition_id2, name: competition_name2, code: competition_code2,
                                  type: competition_type2,
                                  numberOfAvailableSeasons: competition_number_of_available_seasons2)

    competition_id3 = 3
    competition_name3 = 'name3'
    competition_code3 = 'code3'
    competition_type3 = 'type3'
    competition_number_of_available_seasons3 = 10

    competition3 = OpenStruct.new(id: competition_id3, name: competition_name3, code: competition_code3,
                                  type: competition_type3,
                                  numberOfAvailableSeasons: competition_number_of_available_seasons3)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    expected_found_competition1 = Competition.new(competition_id1.to_s, competition_name1, competition_code1,
                                                  competition_type1, competition_number_of_available_seasons1.to_s)
    expected_found_competition2 = Competition.new(competition_id2.to_s, competition_name2, competition_code2,
                                                  competition_type2, competition_number_of_available_seasons2.to_s)
    expected_found_competition3 = Competition.new(competition_id3.to_s, competition_name3, competition_code3,
                                                  competition_type3, competition_number_of_available_seasons3.to_s)

    database_operations_dao.insert_competition(competition1)
    database_operations_dao.insert_competition(competition2)
    database_operations_dao.insert_competition(competition3)

    # action
    result = database_operations_dao.select_all_competitions

    # assert
    assert_equal(3, result.size)
    assert_equal([expected_found_competition1, expected_found_competition2, expected_found_competition3], result)
  end

  def test_select_competition_by_id_with_not_found_competition
    # prepare
    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    # action
    result = database_operations_dao.select_competition_by_id(1)

    # assert
    assert_nil(result)
  end

  def test_select_competition_by_id_with_found_competition
    # prepare
    competition_id = 1
    competition_name = 'name'
    competition_code = 'code'
    competition_type = 'type'
    competition_number_of_available_seasons = 5

    competition = OpenStruct.new(id: competition_id, name: competition_name, code: competition_code,
                                 type: competition_type,
                                 numberOfAvailableSeasons: competition_number_of_available_seasons)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    expected_found_competition = Competition.new(competition_id.to_s, competition_name, competition_code,
                                                 competition_type, competition_number_of_available_seasons.to_s)

    database_operations_dao.insert_competition(competition)
    # action
    result = database_operations_dao.select_competition_by_id(competition_id)

    # assert
    assert_equal(expected_found_competition, result)
  end

  def test_select_all_teams_with_empty_teams
    # prepare
    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    # action
    result = database_operations_dao.select_all_teams

    # assert
    assert_equal(0, result.size)
    assert_equal([], result)
  end

  def test_select_all_teams_with_multiple_teams
    # prepare
    team_id1 = 1
    team_name1 = 'name1'

    team1 = OpenStruct.new(id: team_id1, name: team_name1)

    team_id2 = 2
    team_name2 = 'name2'

    team2 = OpenStruct.new(id: team_id2, name: team_name2)

    team_id3 = 3
    team_name3 = 'name3'

    team3 = OpenStruct.new(id: team_id3, name: team_name3)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    expected_found_team1 = Team.new(team_id1.to_s, team_name1)
    expected_found_team2 = Team.new(team_id2.to_s, team_name2)
    expected_found_team3 = Team.new(team_id3.to_s, team_name3)

    database_operations_dao.insert_team(team1)
    database_operations_dao.insert_team(team2)
    database_operations_dao.insert_team(team3)

    # action
    result = database_operations_dao.select_all_teams

    # assert
    assert_equal(3, result.size)
    assert_equal([expected_found_team1, expected_found_team2, expected_found_team3], result)
  end

  def test_select_team_by_id_with_not_found_team
    # prepare
    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    # action
    result = database_operations_dao.select_team_by_id(1)

    # assert
    assert_nil(result)
  end

  def test_select_team_by_id_with_found_team
    # prepare
    team_id = 1
    team_name = 'name'

    team = OpenStruct.new(id: team_id, name: team_name)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    expected_found_team = Team.new(team_id.to_s, team_name)

    database_operations_dao.insert_team(team)
    # action
    result = database_operations_dao.select_team_by_id(team_id)

    # assert
    assert_equal(expected_found_team, result)
  end

  def test_select_competition_by_name_with_not_found_competition
    # prepare
    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    # action
    result = database_operations_dao.select_competition_by_name('name')

    # assert
    assert_nil(result)
  end

  def test_select_competition_by_name_with_found_competition
    # prepare
    competition_id = 1
    competition_name = 'name'
    competition_code = 'code'
    competition_type = 'type'
    competition_number_of_available_seasons = 5

    competition = OpenStruct.new(id: competition_id, name: competition_name, code: competition_code,
                                 type: competition_type,
                                 numberOfAvailableSeasons: competition_number_of_available_seasons)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    expected_found_competition = Competition.new(competition_id.to_s, competition_name, competition_code,
                                                 competition_type, competition_number_of_available_seasons.to_s)

    database_operations_dao.insert_competition(competition)
    # action
    result = database_operations_dao.select_competition_by_name(competition_name)

    # assert
    assert_equal(expected_found_competition, result)
  end

  def test_select_competition_by_code_with_not_found_competition
    # prepare
    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    # action
    result = database_operations_dao.select_competition_by_code('code')

    # assert
    assert_nil(result)
  end

  def test_select_competition_by_code_with_found_competition
    # prepare
    competition_id = 1
    competition_name = 'name'
    competition_code = 'code'
    competition_type = 'type'
    competition_number_of_available_seasons = 5

    competition = OpenStruct.new(id: competition_id, name: competition_name, code: competition_code,
                                 type: competition_type,
                                 numberOfAvailableSeasons: competition_number_of_available_seasons)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    expected_found_competition = Competition.new(competition_id.to_s, competition_name, competition_code,
                                                 competition_type, competition_number_of_available_seasons.to_s)

    database_operations_dao.insert_competition(competition)
    # action
    result = database_operations_dao.select_competition_by_code(competition_code)

    # assert
    assert_equal(expected_found_competition, result)
  end

  def test_select_team_by_name_with_not_found_team
    # prepare
    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    # action
    result = database_operations_dao.select_team_by_name('name')

    # assert
    assert_nil(result)
  end

  def test_select_team_by_name_with_found_team
    # prepare
    team_id = 1
    team_name = 'name'

    team = OpenStruct.new(id: team_id, name: team_name)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    expected_found_team = Team.new(team_id.to_s, team_name)

    database_operations_dao.insert_team(team)
    # action
    result = database_operations_dao.select_team_by_name(team_name)

    # assert
    assert_equal(expected_found_team, result)
  end

  def test_select_teams_in_competition_with_id_with_not_found_competition
    # prepare
    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    # action
    result = database_operations_dao.select_teams_in_competition_with_id(1)

    # assert
    assert_equal(0, result.size)
    assert_equal([], result)
  end

  def test_select_teams_in_competition_with_id_with_found_competition_and_empty_result
    # prepare
    competition_id = 1
    competition_name = 'name'
    competition_code = 'code'
    competition_type = 'type'
    competition_number_of_available_seasons = 5

    competition = OpenStruct.new(id: competition_id, name: competition_name, code: competition_code,
                                 type: competition_type,
                                 numberOfAvailableSeasons: competition_number_of_available_seasons)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    database_operations_dao.insert_competition(competition)

    # action
    result = database_operations_dao.select_teams_in_competition_with_id(competition_id)

    # assert
    assert_equal(0, result.size)
    assert_equal([], result)
  end

  def test_select_teams_in_competition_with_id_with_found_competition_and_found_multiple_teams
    # prepare
    competition_id = 1
    competition_name = 'name'
    competition_code = 'code'
    competition_type = 'type'
    competition_number_of_available_seasons = 5

    competition = OpenStruct.new(id: competition_id, name: competition_name, code: competition_code,
                                 type: competition_type,
                                 numberOfAvailableSeasons: competition_number_of_available_seasons)

    team_id1 = 1
    team_name1 = 'name1'
    team1 = OpenStruct.new(id: team_id1, name: team_name1)

    team_id2 = 2
    team_name2 = 'name2'
    team2 = OpenStruct.new(id: team_id2, name: team_name2)

    team_id3 = 3
    team_name3 = 'name3'
    team3 = OpenStruct.new(id: team_id3, name: team_name3)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    database_operations_dao.insert_competition(competition)
    database_operations_dao.insert_team(team1)
    database_operations_dao.insert_team(team2)
    database_operations_dao.insert_team(team3)
    database_operations_dao.insert_team_competition(team_id1, competition_id)
    database_operations_dao.insert_team_competition(team_id3, competition_id)

    expected_team1 = Team.new(team_id1.to_s, team_name1)
    expected_team3 = Team.new(team_id3.to_s, team_name3)

    # action
    result = database_operations_dao.select_teams_in_competition_with_id(competition_id)

    # assert
    assert_equal(2, result.size)
    assert_equal([expected_team1, expected_team3], result)
  end

  def test_select_matches_for_team_with_id_with_not_existing_team
    # prepare
    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    # action
    result = database_operations_dao.select_matches_for_team_with_id(1)

    # assert
    assert_equal(0, result.size)
    assert_equal([], result)
  end

  def test_select_matches_for_team_with_id_with_no_matches
    # prepare
    team_id = 1
    team_name = 'name'

    team = OpenStruct.new(id: team_id, name: team_name)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    database_operations_dao.insert_team(team)

    # action
    result = database_operations_dao.select_matches_for_team_with_id(team_id)

    # assert
    assert_equal(0, result.size)
    assert_equal([], result)
  end

  def test_select_matches_for_team_with_id_with_multiple_matches
    # prepare
    team_id1 = 1
    team_name1 = 'name1'
    team1 = OpenStruct.new(id: team_id1, name: team_name1)

    team_id2 = 2
    team_name2 = 'name2'
    team2 = OpenStruct.new(id: team_id2, name: team_name2)

    team_id3 = 3
    team_name3 = 'name3'
    team3 = OpenStruct.new(id: team_id3, name: team_name3)

    match_home_team_id1 = team_id1
    match_away_team_id1 = team_id3

    match_home_team1 = OpenStruct.new(id: match_home_team_id1)
    match_away_team1 = OpenStruct.new(id: match_away_team_id1)

    match_half_time_home1 = 1
    match_full_time_home1 = 2
    match_half_time_away1 = 3
    match_full_time_away1 = 4
    match_winner1 = 'winner1'
    match_duration1 = 'duration1'
    match_score1 = OpenStruct.new(halfTime: OpenStruct.new(home: match_half_time_home1, away: match_half_time_away1),
                                  fullTime: OpenStruct.new(home: match_full_time_home1, away: match_full_time_away1),
                                  winner: match_winner1, duration: match_duration1)

    match_id1 = 4
    match_utc_date1 = 'date1'
    match_status1 = 'status1'
    match_matchday1 = 1
    match_stage1 = 'stage1'
    match_last_updated1 = 'lastUpdated1'

    match1 = OpenStruct.new(id: match_id1, utcDate: match_utc_date1, status: match_status1, matchday: match_matchday1,
                            stage: match_stage1, lastUpdated: match_last_updated1, score: match_score1,
                            homeTeam: match_home_team1, awayTeam: match_away_team1)

    match_home_team_id2 = team_id2
    match_away_team_id2 = team_id1

    match_home_team2 = OpenStruct.new(id: match_home_team_id2)
    match_away_team2 = OpenStruct.new(id: match_away_team_id2)

    match_half_time_home2 = 5
    match_full_time_home2 = 6
    match_half_time_away2 = 7
    match_full_time_away2 = 8
    match_winner2 = 'winner2'
    match_duration2 = 'duration2'
    match_score2 = OpenStruct.new(halfTime: OpenStruct.new(home: match_half_time_home2, away: match_half_time_away2),
                                  fullTime: OpenStruct.new(home: match_full_time_home2, away: match_full_time_away2),
                                  winner: match_winner2, duration: match_duration2)

    match_id2 = 5
    match_utc_date2 = 'date2'
    match_status2 = 'status2'
    match_matchday2 = 2
    match_stage2 = 'stage2'
    match_last_updated2 = 'lastUpdated2'

    match2 = OpenStruct.new(id: match_id2, utcDate: match_utc_date2, status: match_status2, matchday: match_matchday2,
                            stage: match_stage2, lastUpdated: match_last_updated2, score: match_score2,
                            homeTeam: match_home_team2, awayTeam: match_away_team2)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    database_operations_dao.insert_team(team1)
    database_operations_dao.insert_team(team2)
    database_operations_dao.insert_team(team3)

    database_operations_dao.insert_team_match(match1)
    database_operations_dao.insert_team_match(match2)

    expected_match1 = Match.new(match_id1.to_s, match_utc_date1, match_status1, match_matchday1.to_s, match_stage1,
                                match_last_updated1, team_id1.to_s, team_name1, team_id3.to_s,
                                team_name3, match_half_time_home1.to_s, match_half_time_away1.to_s,
                                match_full_time_home1.to_s, match_full_time_away1.to_s, match_winner1, match_duration1)

    expected_match2 = Match.new(match_id2.to_s, match_utc_date2, match_status2, match_matchday2.to_s, match_stage2,
                                match_last_updated2, team_id2.to_s, team_name2, team_id1.to_s, team_name1,
                                match_half_time_home2.to_s, match_half_time_away2.to_s,
                                match_full_time_home2.to_s, match_full_time_away2.to_s, match_winner2, match_duration2)

    # action
    result = database_operations_dao.select_matches_for_team_with_id(team_id1)

    # assert
    assert_equal(2, result.size)
    assert_equal([expected_match1, expected_match2], result)
  end

  def test_insert_team_nil
    # prepare
    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    # action
    result = database_operations_dao.insert_team(nil)

    # assert
    assert_nil(result)
    assert_equal(0, database_operations_dao.select_all_teams.size)
  end

  def test_insert_team_not_nil
    # prepare
    team_id = 1
    team_name = 'name'
    team = OpenStruct.new(id: team_id, name: team_name)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    expected_team_found = Team.new(team_id.to_s, team_name)

    # action
    result = database_operations_dao.insert_team(team)

    # assert
    assert_nil(result)
    found_teams = database_operations_dao.select_all_teams
    assert_equal(1, found_teams.size)
    assert_equal([expected_team_found], found_teams)
  end

  def test_remove_team_competitions_for_team_with_id_with_not_found_team
    # prepare
    competition_id = 1
    competition_name = 'name'
    competition_code = 'code'
    competition_type = 'type'
    competition_number_of_available_seasons = 5

    competition = OpenStruct.new(id: competition_id, name: competition_name, code: competition_code,
                                 type: competition_type,
                                 numberOfAvailableSeasons: competition_number_of_available_seasons)

    team_id = 2
    team_name = 'nameTeam'
    team = OpenStruct.new(id: team_id, name: team_name)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    database_operations_dao.insert_competition(competition)
    database_operations_dao.insert_team(team)
    database_operations_dao.insert_team_competition(team_id, competition_id)

    expected_found_team_in_competition = Team.new(team_id.to_s, team_name)

    # action
    result = database_operations_dao.remove_team_competitions_for_team_with_id(3)

    # assert
    assert_nil(result)
    found_teams_in_competition = database_operations_dao.select_teams_in_competition_with_id(competition_id)
    assert_equal(1, found_teams_in_competition.size)
    assert_equal([expected_found_team_in_competition], found_teams_in_competition)
  end

  def test_remove_team_competitions_for_team_with_id_with_found_team
    # prepare
    competition_id = 1
    competition_name = 'name'
    competition_code = 'code'
    competition_type = 'type'
    competition_number_of_available_seasons = 5

    competition = OpenStruct.new(id: competition_id, name: competition_name, code: competition_code,
                                 type: competition_type,
                                 numberOfAvailableSeasons: competition_number_of_available_seasons)

    team_id1 = 2
    team_name1 = 'nameTeam1'
    team1 = OpenStruct.new(id: team_id1, name: team_name1)

    team_id2 = 3
    team_name2 = 'nameTeam2'
    team2 = OpenStruct.new(id: team_id2, name: team_name2)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    database_operations_dao.insert_competition(competition)
    database_operations_dao.insert_team(team1)
    database_operations_dao.insert_team(team2)
    database_operations_dao.insert_team_competition(team_id1, competition_id)
    database_operations_dao.insert_team_competition(team_id2, competition_id)

    expected_found_team_in_competition = Team.new(team_id2.to_s, team_name2)

    # action
    result = database_operations_dao.remove_team_competitions_for_team_with_id(team_id1)

    # assert
    assert_nil(result)
    found_teams_in_competition = database_operations_dao.select_teams_in_competition_with_id(competition_id)
    assert_equal(1, found_teams_in_competition.size)
    assert_equal([expected_found_team_in_competition], found_teams_in_competition)
  end

  def test_insert_team_competition
    # prepare
    competition_id = 1
    competition_name = 'name'
    competition_code = 'code'
    competition_type = 'type'
    competition_number_of_available_seasons = 5

    competition = OpenStruct.new(id: competition_id, name: competition_name, code: competition_code,
                                 type: competition_type,
                                 numberOfAvailableSeasons: competition_number_of_available_seasons)

    team_id1 = 2
    team_name1 = 'nameTeam1'
    team1 = OpenStruct.new(id: team_id1, name: team_name1)

    team_id2 = 3
    team_name2 = 'nameTeam2'
    team2 = OpenStruct.new(id: team_id2, name: team_name2)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    database_operations_dao.insert_competition(competition)
    database_operations_dao.insert_team(team1)
    database_operations_dao.insert_team(team2)

    expected_found_team_in_competition1 = Team.new(team_id1.to_s, team_name1)
    expected_found_team_in_competition2 = Team.new(team_id2.to_s, team_name2)

    # action
    database_operations_dao.insert_team_competition(team_id1, competition_id)
    result = database_operations_dao.insert_team_competition(team_id2, competition_id)

    # assert
    assert_nil(result)
    found_teams_in_competition = database_operations_dao.select_teams_in_competition_with_id(competition_id)
    assert_equal(2, found_teams_in_competition.size)
    assert_equal([expected_found_team_in_competition1, expected_found_team_in_competition2], found_teams_in_competition)
  end

  def test_insert_team_match
    # prepare
    team_id1 = 1
    team_name1 = 'name1'
    team1 = OpenStruct.new(id: team_id1, name: team_name1)

    team_id2 = 2
    team_name2 = 'name2'
    team2 = OpenStruct.new(id: team_id2, name: team_name2)

    team_id3 = 3
    team_name3 = 'name3'
    team3 = OpenStruct.new(id: team_id3, name: team_name3)

    match_home_team_id1 = team_id1
    match_away_team_id1 = team_id3

    match_home_team1 = OpenStruct.new(id: match_home_team_id1)
    match_away_team1 = OpenStruct.new(id: match_away_team_id1)

    match_half_time_home1 = 1
    match_full_time_home1 = 2
    match_half_time_away1 = 3
    match_full_time_away1 = 4
    match_winner1 = 'winner1'
    match_duration1 = 'duration1'
    match_score1 = OpenStruct.new(halfTime: OpenStruct.new(home: match_half_time_home1, away: match_half_time_away1),
                                  fullTime: OpenStruct.new(home: match_full_time_home1, away: match_full_time_away1),
                                  winner: match_winner1, duration: match_duration1)

    match_id1 = 4
    match_utc_date1 = 'date1'
    match_status1 = 'status1'
    match_matchday1 = 1
    match_stage1 = 'stage1'
    match_last_updated1 = 'lastUpdated1'

    match1 = OpenStruct.new(id: match_id1, utcDate: match_utc_date1, status: match_status1, matchday: match_matchday1,
                            stage: match_stage1, lastUpdated: match_last_updated1, score: match_score1,
                            homeTeam: match_home_team1, awayTeam: match_away_team1)

    match_home_team_id2 = team_id2
    match_away_team_id2 = team_id1

    match_home_team2 = OpenStruct.new(id: match_home_team_id2)
    match_away_team2 = OpenStruct.new(id: match_away_team_id2)

    match_half_time_home2 = 5
    match_full_time_home2 = 6
    match_half_time_away2 = 7
    match_full_time_away2 = 8
    match_winner2 = 'winner2'
    match_duration2 = 'duration2'
    match_score2 = OpenStruct.new(halfTime: OpenStruct.new(home: match_half_time_home2, away: match_half_time_away2),
                                  fullTime: OpenStruct.new(home: match_full_time_home2, away: match_full_time_away2),
                                  winner: match_winner2, duration: match_duration2)

    match_id2 = 5
    match_utc_date2 = 'date2'
    match_status2 = 'status2'
    match_matchday2 = 2
    match_stage2 = 'stage2'
    match_last_updated2 = 'lastUpdated2'

    match2 = OpenStruct.new(id: match_id2, utcDate: match_utc_date2, status: match_status2, matchday: match_matchday2,
                            stage: match_stage2, lastUpdated: match_last_updated2, score: match_score2,
                            homeTeam: match_home_team2, awayTeam: match_away_team2)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    database_operations_dao.insert_team(team1)
    database_operations_dao.insert_team(team2)
    database_operations_dao.insert_team(team3)

    database_operations_dao.insert_team_match(match1)
    database_operations_dao.insert_team_match(match2)

    expected_match1 = Match.new(match_id1.to_s, match_utc_date1, match_status1, match_matchday1.to_s, match_stage1,
                                match_last_updated1, team_id1.to_s, team_name1, team_id3.to_s,
                                team_name3, match_half_time_home1.to_s, match_half_time_away1.to_s,
                                match_full_time_home1.to_s, match_full_time_away1.to_s, match_winner1, match_duration1)

    expected_match2 = Match.new(match_id2.to_s, match_utc_date2, match_status2, match_matchday2.to_s, match_stage2,
                                match_last_updated2, team_id2.to_s, team_name2, team_id1.to_s, team_name1,
                                match_half_time_home2.to_s, match_half_time_away2.to_s,
                                match_full_time_home2.to_s, match_full_time_away2.to_s, match_winner2, match_duration2)

    # action
    result = database_operations_dao.select_matches_for_team_with_id(team_id1)

    # assert
    assert_equal(2, result.size)
    assert_equal([expected_match1, expected_match2], result)
  end

  def test_remove_all_competitions
    # prepare
    competition_id1 = 1
    competition_name1 = 'name1'
    competition_code1 = 'code1'
    competition_type1 = 'type1'
    competition_number_of_available_seasons1 = 5

    competition1 = OpenStruct.new(id: competition_id1, name: competition_name1, code: competition_code1,
                                  type: competition_type1,
                                  numberOfAvailableSeasons: competition_number_of_available_seasons1)

    competition_id2 = 2
    competition_name2 = 'name2'
    competition_code2 = 'code2'
    competition_type2 = 'type2'
    competition_number_of_available_seasons2 = 5

    competition2 = OpenStruct.new(id: competition_id2, name: competition_name2, code: competition_code2,
                                  type: competition_type2,
                                  numberOfAvailableSeasons: competition_number_of_available_seasons2)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    database_operations_dao.insert_competition(competition1)
    database_operations_dao.insert_competition(competition2)

    assert_equal(2, database_operations_dao.select_all_competitions.size)

    # action
    result = database_operations_dao.remove_all_competitions

    # assert
    assert_nil(result)
    assert_equal(0, database_operations_dao.select_all_competitions.size)
  end

  def test_remove_all_teams
    # prepare
    team_id1 = 1
    team_name1 = 'name1'

    team1 = OpenStruct.new(id: team_id1, name: team_name1)

    team_id2 = 2
    team_name2 = 'name2'

    team2 = OpenStruct.new(id: team_id2, name: team_name2)

    team_id3 = 3
    team_name3 = 'name3'

    team3 = OpenStruct.new(id: team_id3, name: team_name3)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    database_operations_dao.insert_team(team1)
    database_operations_dao.insert_team(team2)
    database_operations_dao.insert_team(team3)

    assert_equal(3, database_operations_dao.select_all_teams.size)

    # action
    result = database_operations_dao.remove_all_teams

    # assert
    assert_nil(result)
    assert_equal(0, database_operations_dao.select_all_teams.size)
  end

  def test_remove_all_teams_competitions
    # prepare
    competition_id1 = 1
    competition_name1 = 'name1'
    competition_code1 = 'code1'
    competition_type1 = 'type1'
    competition_number_of_available_seasons1 = 5

    competition1 = OpenStruct.new(id: competition_id1, name: competition_name1, code: competition_code1,
                                  type: competition_type1,
                                  numberOfAvailableSeasons: competition_number_of_available_seasons1)

    competition_id2 = 11
    competition_name2 = 'name2'
    competition_code2 = 'code2'
    competition_type2 = 'type2'
    competition_number_of_available_seasons2 = 15

    competition2 = OpenStruct.new(id: competition_id2, name: competition_name2, code: competition_code2,
                                  type: competition_type2,
                                  numberOfAvailableSeasons: competition_number_of_available_seasons2)

    team_id1 = 1
    team_name1 = 'name1'
    team1 = OpenStruct.new(id: team_id1, name: team_name1)

    team_id2 = 2
    team_name2 = 'name2'
    team2 = OpenStruct.new(id: team_id2, name: team_name2)

    team_id3 = 3
    team_name3 = 'name3'
    team3 = OpenStruct.new(id: team_id3, name: team_name3)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    database_operations_dao.insert_competition(competition1)
    database_operations_dao.insert_competition(competition2)
    database_operations_dao.insert_team(team1)
    database_operations_dao.insert_team(team2)
    database_operations_dao.insert_team(team3)
    database_operations_dao.insert_team_competition(team_id1, competition_id1)
    database_operations_dao.insert_team_competition(team_id2, competition_id1)
    database_operations_dao.insert_team_competition(team_id3, competition_id1)
    database_operations_dao.insert_team_competition(team_id2, competition_id2)
    database_operations_dao.insert_team_competition(team_id3, competition_id2)

    assert_equal(3, database_operations_dao.select_teams_in_competition_with_id(competition_id1).size)
    assert_equal(2, database_operations_dao.select_teams_in_competition_with_id(competition_id2).size)

    # action
    result = database_operations_dao.remove_all_teams_competitions

    # assert
    assert_nil(result)
    assert_equal(0, database_operations_dao.select_teams_in_competition_with_id(competition_id1).size)
    assert_equal(0, database_operations_dao.select_teams_in_competition_with_id(competition_id2).size)
  end

  def test_remove_all_matches
    # prepare
    team_id1 = 1
    team_name1 = 'name1'
    team1 = OpenStruct.new(id: team_id1, name: team_name1)

    team_id2 = 2
    team_name2 = 'name2'
    team2 = OpenStruct.new(id: team_id2, name: team_name2)

    team_id3 = 3
    team_name3 = 'name3'
    team3 = OpenStruct.new(id: team_id3, name: team_name3)

    match_home_team_id1 = team_id1
    match_away_team_id1 = team_id3

    match_home_team1 = OpenStruct.new(id: match_home_team_id1)
    match_away_team1 = OpenStruct.new(id: match_away_team_id1)

    match_half_time_home1 = 1
    match_full_time_home1 = 2
    match_half_time_away1 = 3
    match_full_time_away1 = 4
    match_winner1 = 'winner1'
    match_duration1 = 'duration1'
    match_score1 = OpenStruct.new(halfTime: OpenStruct.new(home: match_half_time_home1, away: match_half_time_away1),
                                  fullTime: OpenStruct.new(home: match_full_time_home1, away: match_full_time_away1),
                                  winner: match_winner1, duration: match_duration1)

    match_id1 = 4
    match_utc_date1 = 'date1'
    match_status1 = 'status1'
    match_matchday1 = 1
    match_stage1 = 'stage1'
    match_last_updated1 = 'lastUpdated1'

    match1 = OpenStruct.new(id: match_id1, utcDate: match_utc_date1, status: match_status1, matchday: match_matchday1,
                            stage: match_stage1, lastUpdated: match_last_updated1, score: match_score1,
                            homeTeam: match_home_team1, awayTeam: match_away_team1)

    match_home_team_id2 = team_id2
    match_away_team_id2 = team_id1

    match_home_team2 = OpenStruct.new(id: match_home_team_id2)
    match_away_team2 = OpenStruct.new(id: match_away_team_id2)

    match_half_time_home2 = 5
    match_full_time_home2 = 6
    match_half_time_away2 = 7
    match_full_time_away2 = 8
    match_winner2 = 'winner2'
    match_duration2 = 'duration2'
    match_score2 = OpenStruct.new(halfTime: OpenStruct.new(home: match_half_time_home2, away: match_half_time_away2),
                                  fullTime: OpenStruct.new(home: match_full_time_home2, away: match_full_time_away2),
                                  winner: match_winner2, duration: match_duration2)

    match_id2 = 5
    match_utc_date2 = 'date2'
    match_status2 = 'status2'
    match_matchday2 = 2
    match_stage2 = 'stage2'
    match_last_updated2 = 'lastUpdated2'

    match2 = OpenStruct.new(id: match_id2, utcDate: match_utc_date2, status: match_status2, matchday: match_matchday2,
                            stage: match_stage2, lastUpdated: match_last_updated2, score: match_score2,
                            homeTeam: match_home_team2, awayTeam: match_away_team2)

    database_operations_dao = DatabaseOperationsDao.new(TEST_DATABSE_NAME, TEST_DATABASE_USER, TEST_DATABASE_PASSWORD)

    database_operations_dao.insert_team(team1)
    database_operations_dao.insert_team(team2)
    database_operations_dao.insert_team(team3)

    database_operations_dao.insert_team_match(match1)
    database_operations_dao.insert_team_match(match2)

    assert_equal(2, database_operations_dao.select_matches_for_team_with_id(team_id1).size)
    assert_equal(1, database_operations_dao.select_matches_for_team_with_id(team_id2).size)
    assert_equal(1, database_operations_dao.select_matches_for_team_with_id(team_id3).size)

    # action
    result = database_operations_dao.remove_all_matches

    # assert
    assert_nil(result)
    assert_equal(0, database_operations_dao.select_matches_for_team_with_id(team_id1).size)
    assert_equal(0, database_operations_dao.select_matches_for_team_with_id(team_id2).size)
    assert_equal(0, database_operations_dao.select_matches_for_team_with_id(team_id3).size)
  end

  private

  def create_database
    connection = PG.connect(dbname: 'postgres', user: TEST_DATABASE_USER, password: TEST_DATABASE_PASSWORD)
    begin
      connection.exec("CREATE DATABASE #{TEST_DATABSE_NAME};")
    rescue PG::Error => e
      puts("An error occured when creating test databse: #{e.message}")
    ensure
      connection&.close
    end

    database_schema = File.read('./resources/Database.sql')
    connection = PG.connect(dbname: TEST_DATABSE_NAME, user: TEST_DATABASE_USER, password: TEST_DATABASE_PASSWORD)
    begin
      connection.exec(database_schema)
    rescue PG::Error => e
      puts("An error occured when creating test databse: #{e.message}")
    ensure
      connection&.close
    end
  end

  def drop_database
    connection = PG.connect(dbname: 'postgres', user: TEST_DATABASE_USER, password: TEST_DATABASE_PASSWORD)
    begin
      connection.exec("DROP DATABASE #{TEST_DATABSE_NAME};")
    rescue PG::Error => e
      puts("An error occured when destroying test databse: #{e.message}")
    ensure
      connection&.close
    end
  end
end
