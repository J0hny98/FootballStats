require 'thor'
require_relative './football_stats/service/crawler_service'
require_relative './football_stats/service/database_operations_service'

# Football stats class
class FootballStats < Thor
  DATABASE_NAME = 'football_stats'.freeze
  USER = 'admin'.freeze
  PASSWORD = 'admin'.freeze
  API_KEY = '7fc818b7d73e47d4babe4a58bb25ea81'.freeze

  desc 'select_all_competitions', 'Returns all competitions from the database.'
  def select_all_competitions
    competitions = DatabaseOperationsService.new(DATABASE_NAME, USER,
                                                 PASSWORD).select_all_competitions
    competitions.each(&:pretty_print)
    competitions
  end

  desc 'select_all_teams', 'Returns all teams from the database.'
  def select_all_teams
    teams = DatabaseOperationsService.new(DATABASE_NAME, USER, PASSWORD).select_all_teams
    teams.each(&:pretty_print)
    teams
  end

  desc 'insert_competitions', 'Inserts all competitions loaded from the API and then returns them.'
  def insert_competitions
    CrawlerService.new(API_KEY).put_competitions_to_database
    select_all_competitions
  end

  desc 'insert_teams CLEAN_INSERT', 'Inserts all the teams and their matches
        for the existing competitions and then returns the teams.
        If the CLEAN_INSERT is true, then it first removes the teams and their matches from the database'
  def insert_teams(clean_insert = false)
    if clean_insert
      DatabaseOperationsService.new(DATABASE_NAME, USER, PASSWORD).remove_all_matches
      DatabaseOperationsService.new(DATABASE_NAME, USER, PASSWORD).remove_all_teams_competitions
      DatabaseOperationsService.new(DATABASE_NAME, USER, PASSWORD).remove_all_teams
    end
    CrawlerService.new(API_KEY).put_teams_to_database
    select_all_teams
  end
end
