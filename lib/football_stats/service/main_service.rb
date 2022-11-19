require_relative './crawler_service'
require_relative './database_operations_service'

# Main service class
class MainService
  def initialize(crawler_service, database_operations_service)
    @crawler_service = crawler_service
    @database_operations_service = database_operations_service
  end

  def clean_insert_teams_to_database
    @database_operations_service.remove_all_matches
    @database_operations_service.remove_all_teams_competitions
    @database_operations_service.remove_all_teams
    put_teams_from_api_to_database
    nil
  end

  def put_all_data_to_database
    put_competitions_from_api_to_database
    put_teams_from_api_to_database
    nil
  end

  def put_competitions_from_api_to_database
    competitions = @crawler_service.load_competitions_from_api
    @database_operations_service.insert_batch_competitions(competitions)
    nil
  end

  def put_teams_from_api_to_database
    competitions = @database_operations_service.select_all_competitions
    teams = @crawler_service.load_teams_from_api_for_competitions(competitions)
    @database_operations_service.insert_batch_teams(teams)
    nil
  end

  def put_team_matches_from_api_to_database
    teams = select_all_teams_from_database
    puts "Inserting matches for #{teams.length} teams. It will take probably #{teams.length / 6.0} " \
         'minutes due to an API limitations.'
    counter = 0
    teams.each do |team|
      put_team_matches_for_team_with_id_to_database(team.team_id)
      counter += 1
    end
    nil
  end

  def put_team_matches_for_team_with_id_to_database(team_id)
    matches = @crawler_service.load_matches_from_api_for_team_with_id(team_id)
    @database_operations_service.insert_batch_matches(matches) if !matches.nil? && !matches.empty?
    nil
  end

  def put_team_matches_for_team_with_name_to_database(team_name)
    found_team = select_team_by_name(team_name)
    if found_team.nil?
      nil
    else
      put_team_matches_for_team_with_id_to_database(found_team.team_id)
    end
  end

  def select_all_competitions_from_database
    @database_operations_service.select_all_competitions
  end

  def select_competition_by_code(code)
    @database_operations_service.select_competition_by_code(code)
  end

  def select_competition_by_id(id)
    @database_operations_service.select_competition_by_id(id)
  end

  def select_competition_by_name(name)
    @database_operations_service.select_competition_by_name(name)
  end

  def select_all_teams_from_database
    @database_operations_service.select_all_teams
  end

  def select_team_by_id(id)
    @database_operations_service.select_team_by_id(id)
  end

  def select_team_by_name(name)
    @database_operations_service.select_team_by_name(name)
  end

  def select_teams_in_competition_with_id(competition_id)
    @database_operations_service.select_teams_in_competition_with_id(competition_id)
  end

  def select_teams_in_competition_with_name(competition_name)
    found_competition = select_competition_by_name(competition_name)
    if found_competition.nil?
      []
    else
      @database_operations_service.select_teams_in_competition_with_id(found_competition.competition_id)
    end
  end

  def select_matches_for_team_with_id(team_id)
    @database_operations_service.select_matches_for_team_with_id(team_id)
  end

  def select_matches_for_team_with_name(team_name)
    found_team = select_team_by_name(team_name)
    if found_team.nil?
      []
    else
      select_matches_for_team_with_id(found_team.team_id)
    end
  end

  def remove_all_data_from_database
    remove_all_teams_from_database
    @database_operations_service.remove_all_competitions
    nil
  end

  def remove_all_teams_from_database
    @database_operations_service.remove_all_matches
    @database_operations_service.remove_all_teams_competitions
    @database_operations_service.remove_all_teams
    nil
  end
end
