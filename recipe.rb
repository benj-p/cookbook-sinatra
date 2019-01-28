class Recipe
  attr_reader :name, :description, :prep_time, :done, :difficulty

  def initialize(name, description, prep_time, difficulty = "", done = false)
    @name = name
    @description = description
    @prep_time = prep_time
    @done = done
    @difficulty = difficulty
  end

  def recipe_read!
    @done = true
  end
end

