class WeatherService
  include HTTParty
  base_uri "https://api.openweathermap.org/data/2.5"

  def self.get_by_coordinates(lat, lon)
    cache_key = "weather-full:#{lat.round(2)},#{lon.round(2)}"
    cached = Rails.cache.read(cache_key)
    return [cached, true] if cached

    response = get("/weather", query: {
      lat: lat,
      lon: lon,
      appid: ENV["WEATHER_API_KEY"] || "0f304e708e30e8e4023d713f698add92",
      units: "metric"
    })

    puts "Full Weather API response: #{response.body}"

    if response.success?
      Rails.cache.write(cache_key, response.parsed_response, expires_in: 30.minutes)
      [response.parsed_response, false]
    else
      puts "Weather API error: #{response.body}"
      [{ error: "Unable to fetch weather data", status: response.code }, false]
    end
  end
end
