require 'faraday'
require 'json'

class NasaApiService
  def find_neos_by_date(date)
    conn = Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: ENV['nasa_api_key']}
    )
    parsed_asteroids_data(conn, date)
  end

  def asteroids_list_data(conn)
    conn.get('/neo/rest/v1/feed')
  end

  def parsed_asteroids_data(conn, date)
    JSON.parse(asteroids_list_data(conn).body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  end

  def get_asteroids(date)
    neos = find_neos_by_date(date)
    asteroids = []
    neos.reduce({}) do |collector, asteroid|
      collector = {}
      collector[:name] = asteroid[:name]
      collector[:diameter] = asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
      collector[:miss_distance] = asteroid[:close_approach_data][0][:miss_distance][:miles].to_i
      asteroids << collector
    end
    asteroids
  end
end
