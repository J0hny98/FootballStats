require 'pg'
require_relative '../entity/competition'
require_relative '../entity/match'
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
          '#{escape_single_quotes(competition.name)}',
          '#{escape_single_quotes(competition.code)}',
          '#{escape_single_quotes(competition.type)}',
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
    create_competitions_from_result(result)
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

    if result.ntuples.zero?
      nil
    else
      create_competition_object_from_row(result[0])
    end
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
    create_teams_from_result(result)
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

    if result.ntuples.zero?
      nil
    else
      create_team_object_from_row(result[0])
    end
  end

  def select_competition_by_name(competition_name)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      result = connection.exec("SELECT * FROM #{COMPETITION_TABLE_NAME}
                                WHERE name = '#{escape_single_quotes(competition_name)}';")
    rescue PG::Error => e
      puts("An error occured when retrieving competition with name #{competition_name} from the database: #{e.message}")
    ensure
      connection&.close
    end

    if result.ntuples.zero?
      nil
    else
      create_competition_object_from_row(result[0])
    end
  end

  def select_competition_by_code(competition_code)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      result = connection.exec("SELECT * FROM #{COMPETITION_TABLE_NAME}
                                WHERE code = '#{escape_single_quotes(competition_code)}';")
    rescue PG::Error => e
      puts("An error occured when retrieving competition with code #{competition_code} from the database: #{e.message}")
    ensure
      connection&.close
    end

    if result.ntuples.zero?
      nil
    else
      create_competition_object_from_row(result[0])
    end
  end

  def select_team_by_name(team_name)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      result = connection.exec("SELECT * FROM #{TEAM_TABLE_NAME} WHERE name = '#{escape_single_quotes(team_name)}';")
    rescue PG::Error => e
      puts("An error occured when retrieving team with name #{team_name} from the database: #{e.message}")
    ensure
      connection&.close
    end

    if result.ntuples.zero?
      nil
    else
      create_team_object_from_row(result[0])
    end
  end

  def select_teams_in_competition_with_id(competition_id)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      result = connection.exec("SELECT * FROM team t WHERE t.team_id in
        (SELECT tc.team_id FROM team_competition tc WHERE tc.competition_id = #{competition_id});")
    rescue PG::Error => e
      puts("An error occured when retrieving teams from competition with id #{competition_id}
            from the database: #{e.message}")
    ensure
      connection&.close
    end
    create_teams_from_result(result)
  end

  def select_matches_for_team_with_id(team_id)
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      result = connection.exec("SELECT * FROM match m
                                WHERE m.home_team_id = #{team_id} or m.away_team_id = #{team_id};")
    rescue PG::Error => e
      puts("An error occured when retrieving matches of team with id #{team_id} from the database: #{e.message}")
    ensure
      connection&.close
    end
    create_matches_from_result(result)
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
              '#{escape_single_quotes(team.name)}'
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

  def remove_team_competitions_for_team_with_id(team_id)
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

  def insert_team_match(match)
    matchday = match.matchday.nil? ? 'null' : match.matchday
    half_time_home = match.score.halfTime.home.nil? ? 'null' : match.score.halfTime.home
    full_time_home = match.score.fullTime.home.nil? ? 'null' : match.score.fullTime.home
    half_time_away = match.score.halfTime.away.nil? ? 'null' : match.score.halfTime.away
    full_time_away = match.score.fullTime.away.nil? ? 'null' : match.score.fullTime.away
    connection = PG.connect(dbname: @database_name, user: @user, password: @password)
    begin
      cmd = "INSERT INTO #{MATCH_TABLE_NAME}
      (
        match_id,
        utc_date,
        status,
        matchday,
        stage,
        last_updated,
        home_team_id,
        away_team_id,
        home_half_time,
        home_full_time,
        away_half_time,
        away_full_time,
        winner,
        duration
      )
    VALUES
      (
        #{match.id},
        '#{escape_single_quotes(match.utcDate)}',
        '#{escape_single_quotes(match.status)}',
        #{matchday},
        '#{escape_single_quotes(match.stage)}',
        '#{escape_single_quotes(match.lastUpdated)}',
        #{match.homeTeam.id},
        #{match.awayTeam.id},
        #{half_time_home},
        #{full_time_home},
        #{half_time_away},
        #{full_time_away},
        '#{escape_single_quotes(match.score.winner)}',
        '#{escape_single_quotes(match.score.duration)}'
      )
    ON CONFLICT (match_id) DO UPDATE SET
      utc_date = EXCLUDED.utc_date,
      status = EXCLUDED.status,
      matchday = EXCLUDED.matchday,
      stage = EXCLUDED.stage,
      last_updated = EXCLUDED.last_updated,
      home_team_id = EXCLUDED.home_team_id,
      away_team_id = EXCLUDED.away_team_id,
      home_half_time = EXCLUDED.home_half_time,
      home_full_time = EXCLUDED.home_full_time,
      away_half_time = EXCLUDED.away_half_time,
      away_full_time = EXCLUDED.away_full_time,
      winner = EXCLUDED.winner,
      duration = EXCLUDED.duration
    ;"
      connection.exec(cmd)
    rescue PG::Error => e
      puts("An error occured when inserting team match with id #{match.id}
            to the database and command #{cmd}: #{e.message}")
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

  private

  def create_teams_from_result(result)
    teams = []
    result.each do |row|
      teams.append(create_team_object_from_row(row))
    end
    teams
  end

  def create_team_object_from_row(row)
    Team.new(row['team_id'], row['name'])
  end

  def create_competitions_from_result(result)
    competitions = []
    result.each do |row|
      competitions.append(create_competition_object_from_row(row))
    end
    competitions
  end

  def create_competition_object_from_row(row)
    Competition.new(row['competition_id'], row['name'], row['code'], row['type'], row['number_of_available_seasons'])
  end

  def create_matches_from_result(result)
    matches = []
    result.each do |row|
      home_team = select_team_by_id(row['home_team_id'])
      away_team = select_team_by_id(row['away_team_id'])
      matches.append(create_match_object_from_row(row, home_team, away_team))
    end
    matches
  end

  def create_match_object_from_row(row, home_team, away_team)
    Match.new(row['match_id'], row['utc_date'], row['status'], row['matchday'],
      row['stage'], row['last_updated'], row['home_team_id'], home_team&.name,
      row['away_team_id'], away_team&.name, row['home_half_time'], row['away_half_time'],
      row['home_full_time'], row['away_full_time'], row['winner'], row['duration'])
  end

  def escape_single_quotes(message)
    if message.nil?
      nil
    else
      message.gsub("'", "''")
    end
  end
end
