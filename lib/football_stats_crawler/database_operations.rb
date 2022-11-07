require 'pg'
require_relative './competition'

# DatabaseOperations class
class DatabaseOperations
  COMPETITION_TABLE_NAME = 'competition'.freeze
  TEAM_COMPETITION_TABLE_NAME = 'team_competition'.freeze
  TEAM_TABLE_NAME = 'team'.freeze

  def initialize(database_name, user, password)
    @database_name = database_name
    @user = user
    @password = password
  end

  def insert_batch_competitions(competitions_array)
    begin
      connection = PG.connect(dbname: @database_name, user: @user, password: @password)
      competitions_array.each do |competition|
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
        end
      end
    rescue PG::Error => e
      puts("An error occured when inserting competitions to the database: #{e.message}")
    ensure
      connection&.close
    end
  end

  def get_all_available_competitions
    begin
      connection = PG.connect(dbname: @database_name, user: @user, password: @password)
      result = connection.exec("SELECT * FROM #{COMPETITION_TABLE_NAME};")
      available_commpetitions = []
      result.each do |row|
        available_commpetitions.append(Competition.new(row['competition_id'], row['name'], row['code'], row['type'], row['number_of_available_seasons']))
      end
    rescue PG::Error => e
      puts("An error occured when retrieving competitions from the database: #{e.message}")
    ensure
      connection&.close
    end
    available_commpetitions
  end

  def insert_batch_teams(teams_array)
    begin
      connection = PG.connect(dbname: @database_name, user: @user, password: @password)
      teams_array.each do |team|
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
        end

        begin
          connection.exec("DELETE FROM #{TEAM_COMPETITION_TABLE_NAME} WHERE team_id = #{team.id};")

          team.runningCompetitions.each do |competition|
            connection.exec("INSERT INTO #{TEAM_COMPETITION_TABLE_NAME}
                (
                  team_id,
                  competition_id
                )
              VALUES
                (
                  #{team.id},
                  #{competition.id}
                )
              ;") 
          end
        rescue PG::Error => e
          puts("An error occured when inserting team_competition relation to the database for the team #{team.name}: #{e.message}")
        end
      end
    rescue PG::Error => e
      puts("An error occured when inserting teams and team_competition relations to the database: #{e.message}")
    ensure
      connection&.close
    end
  end
end
