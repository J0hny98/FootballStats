require 'pg'
require_relative './competition'

# DatabaseOperations class
class DatabaseOperations
  COMPETITION_TABLE_NAME = 'competition'.freeze

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
          connection.exec("DELETE FROM #{COMPETITION_TABLE_NAME} WHERE competition_id = #{competition.id}")
          connection.exec(%"INSERT INTO #{COMPETITION_TABLE_NAME}
            (competition_id, name, code, type, number_of_available_seasons)
            VALUES
            (#{competition.id}, '#{competition.name}', '#{competition.code}', '#{competition.type}', #{competition.numberOfAvailableSeasons});")
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
end
