class WeatherController < ApplicationController
  def index
    @latitude = request.location.latitude
    @longitude = request.location.longitude

    forecast = ForecastIO.forecast(@latitude, @longitude)

    @weather_icon = forecast.currently.icon
    #binding.pry
  end
end
