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
end
