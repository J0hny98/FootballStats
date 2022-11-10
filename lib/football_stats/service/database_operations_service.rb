require_relative '../entity/competition'
require_relative '../entity/team'
require_relative '../dao/database_operations_dao'
require_relative './crawler_service'

# DatabaseOperations class
class DatabaseOperationsService
  def initialize(database_name, user, password)
    @database_operations_dao = DatabaseOperationsDao.new(database_name, user, password)
  end

  def insert_batch_competitions(competitions_array)
    competitions_array.each do |competition|
      @database_operations_dao.insert_competition(competition)
    end
  end

  def select_all_competitions
    result = @database_operations_dao.select_all_competitions
    commpetitions = []
    result.each do |row|
      commpetitions.append(Competition.new(row['competition_id'], row['name'], row['code'], row['type'],
                                           row['number_of_available_seasons']))
    end
    commpetitions
  end

  def select_all_teams
    result = @database_operations_dao.select_all_teams
    teams = []
    result.each do |row|
      teams.append(Team.new(row['team_id'], row['name']))
    end
    teams
  end

  def insert_batch_teams(teams_array)
    teams_array.each do |team|
      @database_operations_dao.insert_team(team)
      @database_operations_dao.remove_all_teams_competitions(team.id)
      team.runningCompetitions.each do |competition|
        @database_operations_dao.insert_team_competition(team.id, competition.id)
      end
    end
  end
end
