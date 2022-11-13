require_relative '../entity/competition'
require_relative '../entity/team'
require_relative '../dao/database_operations_dao'
require_relative './crawler_service'

# DatabaseOperations class
class DatabaseOperationsService
  def initialize(database_name, user, password)
    @database_operations_dao = DatabaseOperationsDao.new(database_name, user, password)
  end

  def insert_batch_competitions(competitions)
    competitions.each do |competition|
      @database_operations_dao.insert_competition(competition)
    end
  end

  def select_all_competitions
    found_competitions = @database_operations_dao.select_all_competitions
    commpetitions = []
    found_competitions.each do |row|
      commpetitions.append(Competition.new(row['competition_id'], row['name'], row['code'], row['type'],
                                           row['number_of_available_seasons']))
    end
    commpetitions
  end

  def select_all_teams
    found_teams = @database_operations_dao.select_all_teams
    teams = []
    found_teams.each do |row|
      teams.append(Team.new(row['team_id'], row['name']))
    end
    teams
  end

  def select_competition_by_id(competition_id)
    result = @database_operations_dao.select_competition_by_id(competition_id)
    if result.ntuples.zero?
      nil
    else
      found_competition = result[0]
      Competition.new(found_competition['competition_id'], found_competition['name'], found_competition['code'],
        found_competition['type'], found_competition['number_of_available_seasons'])
    end
  end

  def select_team_by_id(team_id)
    result = @database_operations_dao.select_team_by_id(team_id)
    if result.ntuples.zero?
      nil
    else
      found_team = result[0]
      Team.new(found_team['team_id'], found_team['name'])
    end
  end

  def select_competition_by_name(competition_name)
    result = @database_operations_dao.select_competition_by_name(competition_name)
    if result.ntuples.zero?
      nil
    else
      found_competition = result[0]
      Competition.new(found_competition['competition_id'], found_competition['name'], found_competition['code'],
        found_competition['type'], found_competition['number_of_available_seasons'])
    end
  end

  def select_team_by_name(team_name)
    result = @database_operations_dao.select_team_by_name(team_name)
    if result.ntuples.zero?
      nil
    else
      found_team = result[0]
      Team.new(found_team['team_id'], found_team['name'])
    end
  end

  def select_competition_by_code(competition_code)
    result = @database_operations_dao.select_competition_by_code(competition_code)
    if result.ntuples.zero?
      nil
    else
      found_competition = result[0]
      Competition.new(found_competition['competition_id'], found_competition['name'], found_competition['code'],
        found_competition['type'], found_competition['number_of_available_seasons'])
      end   
  end

  def insert_batch_teams(teams_array)
    teams_array.each do |team|
      @database_operations_dao.insert_team(team)
      @database_operations_dao.remove_team_competition_for_team_with_id(team.id)
      team.runningCompetitions.each do |competition|
        found_competition = select_competition_by_id(competition.id)
        found_team = select_team_by_id(team.id)
        if !found_competition.nil? && !found_team.nil?
          @database_operations_dao.insert_team_competition(team.id, competition.id)
        end
      end
    end
  end

  def remove_all_matches
    @database_operations_dao.remove_all_matches
  end

  def remove_all_teams_competitions
    @database_operations_dao.remove_all_competitions
  end

  def remove_all_teams
    @database_operations_dao.remove_all_teams
  end

  def remove_all_competitions
    @database_operations_dao.remove_all_competitions
  end
end
