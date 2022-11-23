require 'thor'
require_relative './football_stats/dao/database_operations_dao'
require_relative './football_stats/service/crawler_service'
require_relative './football_stats/service/database_operations_service'
require_relative './football_stats/service/main_service'
require_relative './config'

# Football stats class
class FootballStats < Thor
  DATABASE_NAME = Config.database_name
  DATABASE_USER = Config.database_user
  DATABASE_PASSWORD = Config.database_password
  API_BASE_URL = Config.api_base_url
  API_KEY = Config.api_key

  CRAWLER_SERVICE = CrawlerService.new(API_BASE_URL, API_KEY)
  DATABASE_OPERATIONS_DAO = DatabaseOperationsDao.new(DATABASE_NAME, DATABASE_USER, DATABASE_PASSWORD)
  DATABASE_OPERATIONS_SERVICE = DatabaseOperationsService.new(DATABASE_OPERATIONS_DAO)
  MAIN_SERVICE = MainService.new(CRAWLER_SERVICE, DATABASE_OPERATIONS_SERVICE)

  desc 'select_all_competitions', 'Prints and returns all competitions from the database.'
  def select_all_competitions
    competitions = MAIN_SERVICE.select_all_competitions_from_database
    competitions.each(&:pretty_print)
    competitions
  end

  desc 'select_competition_by_code [CODE]', 'Prints and returns competition with the provided [CODE] if exists.'
  def select_competition_by_code(code)
    found_competition = MAIN_SERVICE.select_competition_by_code(code)
    found_competition&.pretty_print
    found_competition
  end

  desc 'select_competition_by_name [NAME]', 'Prints and returns competition with the provided [NAME] if exists.'
  def select_competition_by_name(name)
    found_competition = MAIN_SERVICE.select_competition_by_name(name)
    found_competition&.pretty_print
    found_competition
  end

  desc 'select_competition_by_id [ID]', 'Prints and returns competition with the provided [ID] if exists.'
  def select_competition_by_id(id)
    found_competition = MAIN_SERVICE.select_competition_by_id(id)
    found_competition&.pretty_print
    found_competition
  end

  desc 'select_all_teams', 'Prints and returns all teams from the database.'
  def select_all_teams
    teams = MAIN_SERVICE.select_all_teams_from_database
    teams.each(&:pretty_print)
    teams
  end

  desc 'select_team_by_name [NAME]', 'Prints and returns team with the provided [NAME] if exists.'
  def select_team_by_name(name)
    found_team = MAIN_SERVICE.select_team_by_name(name)
    found_team&.pretty_print
    found_team
  end

  desc 'select_team_by_id [ID]', 'Prints and returns team with the provided [ID] if exists.'
  def select_team_by_id(id)
    found_team = MAIN_SERVICE.select_team_by_id(id)
    found_team&.pretty_print
    found_team
  end

  desc 'select_teams_in_competition_with_id [COMPETITION_ID]',
       'Prints and returns all the teams playing the competition with the provided [COMPETITION_ID] if exists.'
  def select_teams_in_competition_with_id(competition_id)
    found_teams = MAIN_SERVICE.select_teams_in_competition_with_id(competition_id)
    found_teams.each(&:pretty_print)
    found_teams
  end

  desc 'select_teams_in_competition_with_name [COMPETITION_NAME]',
       'Prints and returns all the teams playing the competition with the provided [COMPETITION_NAME] if exists.'
  def select_teams_in_competition_with_name(competition_name)
    found_teams = MAIN_SERVICE.select_teams_in_competition_with_name(competition_name)
    found_teams.each(&:pretty_print)
    found_teams
  end

  desc 'select_matches_for_team_with_id [TEAM_ID]',
       'Prints and returns all matches for team with the provided [TEAM_ID] if exists.'
  def select_matches_for_team_with_id(team_id)
    found_matches = MAIN_SERVICE.select_matches_for_team_with_id(team_id)
    found_matches.each(&:pretty_print)
    found_matches
  end

  desc 'select_matches_for_team_with_name [TEAM_NAME]',
       'Prints and returns all matches for team with the provided [TEAM_NAME] if exists.'
  def select_matches_for_team_with_name(team_name)
    found_matches = MAIN_SERVICE.select_matches_for_team_with_name(team_name)
    found_matches.each(&:pretty_print)
    found_matches
  end

  desc 'insert_competitions', 'Inserts all available competitions loaded from the API, then prints and returns them.'
  def insert_competitions
    MAIN_SERVICE.put_competitions_from_api_to_database
    select_all_competitions
  end

  desc 'insert_teams [CLEAN_INSERT]', 'Inserts all the teams and their matches for the existing competitions,
        then returns and prints the teams.
        If the [CLEAN_INSERT] is true, then it first removes the teams and their matches from the database.'
  def insert_teams(clean_insert: false)
    if clean_insert
      MAIN_SERVICE.clean_insert_teams_to_database
    else
      MAIN_SERVICE.put_teams_from_api_to_database
    end
    select_all_teams
  end

  desc 'clean_update', 'Removes all the data from the database and then inserts the clean loaded data from the API.'
  def clean_update
    MAIN_SERVICE.remove_all_data_from_database
    MAIN_SERVICE.put_all_data_to_database
    MAIN_SERVICE.put_team_matches_from_api_to_database
    nil
  end

  desc 'update_matches_for_team_with_id [TEAM_ID]', 'Updates matches for team with the provided [TEAM_ID].'
  def update_matches_for_team_with_id(team_id)
    MAIN_SERVICE.put_team_matches_for_team_with_id_to_database(team_id)
    nil
  end

  desc 'update_matches_for_team_with_name [TEAM_NAME]', 'Updates matches for team with the provided [TEAM_NAME].'
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
