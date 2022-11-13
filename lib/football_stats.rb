require 'thor'
require_relative './football_stats/service/crawler_service'
require_relative './football_stats/service/database_operations_service'
require_relative './football_stats/service/main_service'

# Football stats class
class FootballStats < Thor
  DATABASE_NAME = 'football_stats'.freeze
  USER = 'admin'.freeze
  PASSWORD = 'admin'.freeze
  API_KEY = '7fc818b7d73e47d4babe4a58bb25ea81'.freeze

  MAIN_SERVICE = MainService.new(DATABASE_NAME, USER, PASSWORD, API_KEY)

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

  desc 'select_team_by_name ID', 'Returns team with id = ID from the database if exists.'
  def select_team_by_id(id)
    found_team = MAIN_SERVICE.select_team_by_id(id)
    found_team&.pretty_print
    found_team
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
  end
end
