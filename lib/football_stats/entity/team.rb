# Team class
class Team
  attr_accessor :team_id, :name

  def initialize(team_id, name)
    @team_id = team_id
    @name = name
  end

  def pretty_print
    puts "ID = #{@team_id}, Name = #{@name}"
  end
end
