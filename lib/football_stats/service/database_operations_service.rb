require_relative '../entity/competition'
require_relative '../entity/team'
require_relative '../entity/match'
require_relative '../dao/database_operations_dao'
require_relative './crawler_service'

# DatabaseOperations class
class DatabaseOperationsService
  def initialize(database_operations_dao)
    @database_operations_dao = database_operations_dao
  end

  def insert_batch_competitions(competitions)
    competitions&.each do |competition|
      @database_operations_dao.insert_competition(competition)
    end
    nil
  end

  def insert_batch_matches(matches)
    matches&.each do |match|
      found_team_home = select_team_by_id(match.homeTeam.id)
      found_team_away = select_team_by_id(match.awayTeam.id)
      @database_operations_dao.insert_team_match(match) if !found_team_home.nil? && !found_team_away.nil?
    end
    nil
  end

  def insert_batch_teams(teams)
    teams&.each do |team|
      @database_operations_dao.insert_team(team)
      @database_operations_dao.remove_team_competitions_for_team_with_id(team.id)
      team.runningCompetitions&.each do |competition|
        found_competition = select_competition_by_id(competition.id)
        found_team = select_team_by_id(team.id)
        if !found_competition.nil? && !found_team.nil?
          @database_operations_dao.insert_team_competition(team.id, competition.id)
        end
      end
    end
    nil
  end

  def select_all_competitions
    @database_operations_dao.select_all_competitions
  end

  def select_all_teams
    @database_operations_dao.select_all_teams
  end

  def select_competition_by_id(competition_id)
    @database_operations_dao.select_competition_by_id(competition_id)
  end

  def select_team_by_id(team_id)
    @database_operations_dao.select_team_by_id(team_id)
  end

  def select_competition_by_code(competition_code)
    @database_operations_dao.select_competition_by_code(competition_code)
  end

  def select_competition_by_name(competition_name)
    @database_operations_dao.select_competition_by_name(competition_name)
  end

  def select_team_by_name(team_name)
    @database_operations_dao.select_team_by_name(team_name)
  end

  def select_teams_in_competition_with_id(competition_id)
    found_teams = @database_operations_dao.select_teams_in_competition_with_id(competition_id)
    found_teams.nil? ? [] : found_teams
  end

  def select_matches_for_team_with_id(team_id)
    found_matches = @database_operations_dao.select_matches_for_team_with_id(team_id)
    found_matches.nil? ? [] : found_matches
  end

  def remove_all_matches
    @database_operations_dao.remove_all_matches
    nil
  end

  def remove_all_teams_competitions
    @database_operations_dao.remove_all_teams_competitions
    nil
  end

  def remove_all_teams
    @database_operations_dao.remove_all_teams
    nil
  end

  def remove_all_competitions
    @database_operations_dao.remove_all_competitions
    nil
  end
end
