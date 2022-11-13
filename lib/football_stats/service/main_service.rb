require_relative './crawler_service'
require_relative './database_operations_service'

# Main service class
class MainService
  def initialize(database_name, user, password, api_key)
    @crawler_service = CrawlerService.new(api_key)
    @database_operations_service = DatabaseOperationsService.new(database_name, user, password)
  end

  def clean_insert_teams_to_database
    @database_operations_service.remove_all_matches
    @database_operations_service.remove_all_teams_competitions
    @database_operations_service.remove_all_teams
    put_teams_from_api_to_database
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

  def remove_all_data_from_database
    @database_operations_service.remove_all_matches
    @database_operations_service.remove_all_teams_competitions
    @database_operations_service.remove_all_teams
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
