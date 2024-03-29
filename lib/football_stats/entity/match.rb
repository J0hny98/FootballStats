# Match class
class Match
  attr_accessor :match_id, :utc_date, :status, :matchday, :stage, :last_updated, :home_team_id, :home_team_name,
                :away_team_id, :away_team_name, :home_half_time, :away_half_time, :home_full_time, :away_full_time,
                :winner, :duration

  def initialize(match_id, utc_date, status, matchday, stage, last_updated, home_team_id, home_team_name, away_team_id,
                 away_team_name, home_half_time, away_half_time, home_full_time, away_full_time, winner, duration)
    @match_id = match_id
    @utc_date = utc_date
    @status = status
    @matchday = matchday
    @stage = stage
    @last_updated = last_updated
    @home_team_id = home_team_id
    @home_team_name = home_team_name
    @away_team_id = away_team_id
    @away_team_name = away_team_name
    @home_half_time = home_half_time
    @away_half_time = away_half_time
    @home_full_time = home_full_time
    @away_full_time = away_full_time
    @winner = winner
    @duration = duration
  end

  def pretty_print
    puts "ID = #{@match_id}, Date = #{@utc_date}, Status = #{@status}, Match day = #{@matchday}, " \
         "Stage = #{@stage}, Duration = #{@duration}, Winner = #{@winner}, Last updated = #{@last_updated}"
    puts "\tHome team <ID> - <NAME> = #{@home_team_id} - #{@home_team_name}, " \
         "Away team <ID> - <NAME> = #{@away_team_id} - #{@away_team_name}"
    puts "\t\tHalf time = #{@home_half_time} : #{@away_half_time}"
    puts "\t\tFull time = #{@home_full_time} : #{@away_full_time}"
  end

  def ==(other)
    other.class == self.class && other.state == state
  end

  protected

  def state
    [@match_id, @utc_date, @status, @matchday, @stage, @last_updated, @home_team_id, @home_team_name,
     @away_team_id, @away_team_name, @home_half_time, @away_half_time, @home_full_time, @away_full_time,
     @winner, @duration]
  end
end
