require_relative '../../../lib/football_stats/entity/competition'
require_relative '../../../lib/football_stats/entity/team'
require_relative '../../../lib/football_stats/entity/match'

# Common steps for tests
class CommonSteps
  class << self
    def create_dummy_competitions(number_of_competitions)
      competitions = []
      number_of_competitions.times do |i|
        competitions.append(Competition.new("id-#{i}", "name-#{i}", "code-#{i}", "type-#{i}",
                                            "number_of_available_seasons-#{i}"))
      end
      competitions
    end

    def create_dummy_teams(number_of_teams)
      teams = []
      number_of_teams.times { |i| teams.append(Team.new("id-#{i}", "name-#{i}")) }
      teams
    end

    def create_dummy_matches(number_of_matches)
      matches = []
      number_of_matches.times do |i|
        matches.append(Match.new("id-#{i}", "utc_date-#{i}", "status-#{i}", "matchday-#{i}", "stage-#{i}",
                                 "last_updated-#{i}", "home_team_id-#{i}", "home_team_name-#{i}", "away_team_id-#{i}",
                                 "away_team_name-#{i}", "home_half_time-#{i}", "away_half_time-#{i}",
                                 "home_full_time-#{i}", "away_full_time-#{i}", "winner-#{i}", "duration-#{i}"))
      end
      matches
    end
  end
end
