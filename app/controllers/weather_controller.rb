class WeatherController < ApplicationController
  def index
    @latitude = request.location.latitude
    @longitude = request.location.longitude
    location = Geocoder.search("#{@latitude},#{@longitude}").first
    forecast = ForecastIO.forecast(@latitude, @longitude)

    @city = location.city
    @state = location.state
    @weather_icon = forecast.currently.icon
    #binding.pry

    #@photos = flickr.photosForLocation(@latitude, @longitude, :accuracy => 6,:extras => 'extras',:per_page => 'per_page',:page => 'page')
  end
end
