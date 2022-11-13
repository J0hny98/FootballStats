require 'pg'
require_relative '../entity/competition'
require_relative '../entity/team'

# DatabaseOperationsDao Class
class DatabaseOperationsDao
  COMPETITION_TABLE_NAME = 'competition'.freeze
  TEAM_COMPETITION_TABLE_NAME = 'team_competition'.freeze
  TEAM_TABLE_NAME = 'team'.freeze
  MATCH_TABLE_NAME = 'match'.freeze

  def initialize(database_name, user, password)
    @database_name = database_name
    @user = user
    @password = password
  end

  def insert_competition(competition)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      connection.exec("INSERT INTO #{COMPETITION_TABLE_NAME}
        (
          competition_id,
          name,
          code,
          type,
          number_of_available_seasons
        )
      VALUES
        (
          #{competition.id},
          '#{competition.name}',
          '#{competition.code}',
          '#{competition.type}',
          #{competition.numberOfAvailableSeasons}
        )
      ON CONFLICT (competition_id) DO UPDATE SET
        name = EXCLUDED.name,
        code = EXCLUDED.code,
        type = EXCLUDED.type,
        number_of_available_seasons = EXCLUDED.number_of_available_seasons
      ;")
    rescue PG::Error => e
      puts("An error occured when inserting competition #{competition.name} to the database: #{e.message}")
    ensure
      connection&.close
    end
    nil
  end

  def select_all_competitions
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      result = connection.exec("SELECT * FROM #{COMPETITION_TABLE_NAME};")
    rescue PG::Error => e
      puts("An error occured when retrieving competitions from the database: #{e.message}")
    ensure
      connection&.close
    end
    result
  end

  def select_competition_by_id(competition_id)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      result = connection.exec("SELECT * FROM #{COMPETITION_TABLE_NAME} WHERE competition_id = #{competition_id};")
    rescue PG::Error => e
      puts("An error occured when retrieving competition with id #{competition_id} from the database: #{e.message}")
    ensure
      connection&.close
    end
    result
  end

  def select_all_teams
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      result = connection.exec("SELECT * FROM #{TEAM_TABLE_NAME};")
    rescue PG::Error => e
      puts("An error occured when retrieving teams from the database: #{e.message}")
    ensure
      connection&.close
    end
    result
  end

  def select_team_by_id(team_id)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      result = connection.exec("SELECT * FROM #{TEAM_TABLE_NAME} WHERE team_id = #{team_id};")
    rescue PG::Error => e
      puts("An error occured when retrieving team with id #{team_id} from the database: #{e.message}")
    ensure
      connection&.close
    end
    result
  end

  def select_competition_by_name(competition_name)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      result = connection.exec("SELECT * FROM #{COMPETITION_TABLE_NAME} WHERE name = '#{competition_name}';")
    rescue PG::Error => e
      puts("An error occured when retrieving competition with name #{competition_name} from the database: #{e.message}")
    ensure
      connection&.close
    end
    result
  end

  def select_competition_by_code(competition_code)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      result = connection.exec("SELECT * FROM #{COMPETITION_TABLE_NAME} WHERE code = '#{competition_code}';")
    rescue PG::Error => e
      puts("An error occured when retrieving competition with code #{competition_code} from the database: #{e.message}")
    ensure
      connection&.close
    end
    result
  end

  def select_team_by_name(team_name)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      result = connection.exec("SELECT * FROM #{TEAM_TABLE_NAME} WHERE name = '#{team_name}';")
    rescue PG::Error => e
      puts("An error occured when retrieving team with name #{team_name} from the database: #{e.message}")
    ensure
      connection&.close
    end
    result
  end

  def insert_team(team)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      connection.exec("INSERT INTO #{TEAM_TABLE_NAME}
            (
              team_id,
              name
            )
          VALUES
            (
              #{team.id},
              '#{team.name}'
            )
          ON CONFLICT (team_id) DO UPDATE SET
            name = EXCLUDED.name
          ;")
    rescue PG::Error => e
      puts("An error occured when inserting team #{team.name} to the database: #{e.message}")
    ensure
      connection&.close
    end
    nil
  end

  def remove_team_competition_for_team_with_id(team_id)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      connection.exec("DELETE FROM #{TEAM_COMPETITION_TABLE_NAME} WHERE team_id = #{team_id};")
    rescue PG::Error => e
      puts("An error occured when removing team competition for team with id #{team_id}
            from the database: #{e.message}")
    ensure
      connection&.close
    end
    nil
  end

  def insert_team_competition(team_id, competition_id)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      connection.exec("INSERT INTO #{TEAM_COMPETITION_TABLE_NAME}
        (
          team_id,
          competition_id
        )
      VALUES
        (
          #{team_id},
          #{competition_id}
        )
      ;")
    rescue PG::Error => e
      puts("An error occured when inserting team competition for team with id #{team_id}
            and competition with id #{competition_id} from the database: #{e.message}")
    ensure
      connection&.close
    end
    nil
  end

  def remove_all_competitions
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      connection.exec("DELETE FROM #{COMPETITION_TABLE_NAME};")
    rescue PG::Error => e
      puts("An error occured when removing all the competitions from the database: #{e.message}")
    ensure
      connection&.close
    end
  end

  def remove_all_teams
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      connection.exec("DELETE FROM #{TEAM_TABLE_NAME};")
    rescue PG::Error => e
      puts("An error occured when removing all the teams from the database: #{e.message}")
    ensure
      connection&.close
    end
  end

  def remove_all_teams_competitions
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      connection.exec("DELETE FROM #{TEAM_COMPETITION_TABLE_NAME};")
    rescue PG::Error => e
      puts("An error occured when removing all the teams competitions from the database: #{e.message}")
    ensure
      connection&.close
    end
  end

  def remove_all_matches
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      connection.exec("DELETE FROM #{MATCH_TABLE_NAME};")
    rescue PG::Error => e
      puts("An error occured when removing all the matches from the database: #{e.message}")
    ensure
      connection&.close
    end
  end
end
