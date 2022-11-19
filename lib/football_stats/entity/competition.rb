# Competition class
class Competition
  attr_accessor :competition_id, :name, :code, :type, :number_of_available_seasons

  def initialize(competition_id, name, code, type, number_of_available_seasons)
    @competition_id = competition_id
    @name = name
    @code = code
    @type = type
    @number_of_available_seasons = number_of_available_seasons
  end

  def pretty_print
    puts "ID = #{@competition_id}, Name = #{@name}, Code = #{@code}, Type = #{@code}, " \
         "Number of available seasons = #{@number_of_available_seasons}"
  end

  def ==(other)
    other.class == self.class && other.state == state
  end

  protected

  def state
    [@competition_id, @name, @code, @type, @number_of_available_seasons]
  end
end
