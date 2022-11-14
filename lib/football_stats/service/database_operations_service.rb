require_relative '../entity/competition'
require_relative '../entity/team'
require_relative '../entity/match'
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
    nil
  end

  def insert_batch_matches(matches)
    matches.each do |match|
      found_team_home = select_team_by_id(match.homeTeam.id)
      found_team_away = select_team_by_id(match.awayTeam.id)
      @database_operations_dao.insert_team_match(match) if !found_team_home.nil? && !found_team_away.nil?
    end
    nil
  end

  def insert_batch_teams(teams)
    teams.each do |team|
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
    nil
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

  def select_teams_in_competition_with_id(competition_id)
    found_teams = @database_operations_dao.select_teams_in_competition_with_id(competition_id)
    teams = []
    found_teams.each do |row|
      teams.append(Team.new(row['team_id'], row['name']))
    end
    teams
  end

  def select_matches_for_team_with_id(team_id)
    found_matches = @database_operations_dao.select_matches_for_team_with_id(team_id)
    matches = []
    found_matches.each do |match|
      home_team = select_team_by_id(match['home_team_id'])
      away_team = select_team_by_id(match['away_team_id'])
      matches.append(Match.new(match['match_id'], match['utc_date'], match['status'], match['matchday'],
        match['stage'], match['last_updated'], home_team.name, away_team.name, match['home_half_time'],
        match['away_half_time'], match['home_full_time'], match['away_full_time'], match['winner'], match['duration']))
    end
    matches
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
