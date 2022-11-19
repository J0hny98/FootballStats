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

  def ==(other)
    other.class == self.class && other.state == state
  end

  protected

  def state
    [@team_id, @name]
  end
end
