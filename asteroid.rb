class Asteroid
  def initialize(data)
    @name = data[:name]
    @diameter = data[:diameter]
    @miss_distance = data[:miss_distance]
  end

  def self.get_asteroids(date)
    @get_asteroids ||= service.get_asteroids(date)
  end

  def self.largest_asteroid_diameter(date)
    @largest_asteroid_diameter ||= get_asteroids(date).max_by do |asteroid|
      asteroid[:diameter]
    end[:diameter]
  end

  def self.total_number_of_asteroids(date)
    get_asteroids(date).count
  end

  def self.formatted_data(date)
    asteroids = []
    get_asteroids(date).reduce({}) do |collector, asteroid|
      collector = {}
      collector[:name] = asteroid[:name]
      collector[:diameter] = "#{asteroid[:diameter]} ft"
      collector[:miss_distance] = "#{asteroid[:miss_distance]} miles"
      asteroids << collector
    end
    asteroids
  end

  def self.service
    NasaApiService.new
  end
end
