require 'thor'
require_relative './football_stats/dao/database_operations_dao'
require_relative './football_stats/service/crawler_service'
require_relative './football_stats/service/database_operations_service'
require_relative './football_stats/service/main_service'

# Football stats class
class FootballStats < Thor
  DATABASE_NAME = 'football_stats'.freeze
  USER = 'admin'.freeze
  PASSWORD = 'admin'.freeze
  API_KEY = '7fc818b7d73e47d4babe4a58bb25ea81'.freeze

  CRAWLER_SERVICE = CrawlerService.new(API_KEY)
  DATABASE_OPERATIONS_DAO = DatabaseOperationsDao.new(DATABASE_NAME, USER, PASSWORD)
  DATABASE_OPERATIONS_SERVICE = DatabaseOperationsService.new(DATABASE_OPERATIONS_DAO)
  MAIN_SERVICE = MainService.new(CRAWLER_SERVICE, DATABASE_OPERATIONS_SERVICE)

  desc 'select_all_competitions', 'Returns all competitions from the database.'
  def select_all_competitions
    competitions = MAIN_SERVICE.select_all_competitions_from_database
    competitions.each(&:pretty_print)
    competitions
  end

  desc 'select_competition_by_code CODE', 'Returns competition with code = CODE from the database if exists.'
  def select_competition_by_code(code)
    found_competition = MAIN_SERVICE.select_competition_by_code(code)
    found_competition&.pretty_print
    found_competition
  end

  desc 'select_competition_by_name NAME', 'Returns competition with name = NAME from the database if exists.'
  def select_competition_by_name(name)
    found_competition = MAIN_SERVICE.select_competition_by_name(name)
    found_competition&.pretty_print
    found_competition
  end

  desc 'select_competition_by_name ID', 'Returns competition with id = ID from the database if exists.'
  def select_competition_by_id(id)
    found_competition = MAIN_SERVICE.select_competition_by_id(id)
    found_competition&.pretty_print
    found_competition
  end

  desc 'select_all_teams', 'Returns all teams from the database.'
  def select_all_teams
    teams = MAIN_SERVICE.select_all_teams_from_database
    teams.each(&:pretty_print)
    teams
  end

  desc 'select_team_by_name NAME', 'Returns team with name = NAME from the database if exists.'
  def select_team_by_name(name)
    found_team = MAIN_SERVICE.select_team_by_name(name)
    found_team&.pretty_print
    found_team
  end

  desc 'select_team_by_id ID', 'Returns team with id = ID from the database if exists.'
  def select_team_by_id(id)
    found_team = MAIN_SERVICE.select_team_by_id(id)
    found_team&.pretty_print
    found_team
  end

  desc 'select_teams_in_competition_with_id COMPETITION_ID',
       'Returns all teams playing competition with id = COMPETITION_ID from the database.'
  def select_teams_in_competition_with_id(competition_id)
    found_teams = MAIN_SERVICE.select_teams_in_competition_with_id(competition_id)
    found_teams.each(&:pretty_print)
    found_teams
  end

  desc 'select_teams_in_competition_with_name COMPETITION_NAME',
       'Returns all teams playing competition with name = COMPETITION_NAME from the database.'
  def select_teams_in_competition_with_name(competition_name)
    found_teams = MAIN_SERVICE.select_teams_in_competition_with_name(competition_name)
    found_teams.each(&:pretty_print)
    found_teams
  end

  desc 'select_matches_for_team_with_id TEAM_ID',
       'Returns all matches for team with id = TEAM_ID from the database.'
  def select_matches_for_team_with_id(team_id)
    found_matches = MAIN_SERVICE.select_matches_for_team_with_id(team_id)
    found_matches.each(&:pretty_print)
    found_matches
  end

  desc 'select_matches_for_team_with_name TEAM_NAME',
       'Returns all matches for team with name = TEAM_NAME from the database.'
  def select_matches_for_team_with_name(team_name)
    found_matches = MAIN_SERVICE.select_matches_for_team_with_name(team_name)
    found_matches.each(&:pretty_print)
    found_matches
  end

  desc 'insert_competitions', 'Inserts all competitions loaded from the API and then returns them.'
  def insert_competitions
    MAIN_SERVICE.put_competitions_from_api_to_database
    select_all_competitions
  end

  desc 'insert_teams CLEAN_INSERT', 'Inserts all the teams and their matches
        for the existing competitions and then returns the teams.
        If the CLEAN_INSERT is true, then it first removes the teams and their matches from the database.'
  def insert_teams(clean_insert: false)
    if clean_insert
      MAIN_SERVICE.clean_insert_teams_to_database
    else
      MAIN_SERVICE.put_teams_from_api_to_database
    end
    select_all_teams
  end

  desc 'clean_update', 'Removes all the data from the database and then inserts the clean loaded data.'
  def clean_update
    MAIN_SERVICE.remove_all_data_from_database
    MAIN_SERVICE.put_all_data_to_database
    MAIN_SERVICE.put_team_matches_from_api_to_database
    nil
  end

  desc 'update_matches_for_team_with_id TEAM_ID', 'Updates matches for team with id TEAM_ID.'
  def update_matches_for_team_with_id(team_id)
    MAIN_SERVICE.put_team_matches_for_team_with_id_to_database(team_id)
    nil
  end

  desc 'update_matches_for_team_with_name TEAM_NAME', 'Updates matches for team with name TEAM_NAME.'
  def update_matches_for_team_with_name(team_name)
    MAIN_SERVICE.put_team_matches_for_team_with_name_to_database(team_name)
    nil
  end

  desc 'remove_all_teams', 'Removes all the teams data from the database.'
  def remove_all_teams
    MAIN_SERVICE.remove_all_teams_from_database
    nil
  end

  desc 'remove_all_data', 'Removes all the data from the database.'
  def remove_all_data
    MAIN_SERVICE.remove_all_data_from_database
    nil
  end
end
