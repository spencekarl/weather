class WeatherController < ApplicationController
  def index
    @latitude = request.location.latitude
    @longitude = request.location.longitude
    # note: investigate whether there's a better way to access location.city
    location = Geocoder.search("#{@latitude},#{@longitude}").first
    forecast = ForecastIO.forecast(@latitude, @longitude)

    # note: refactor everyhing and validate existence of large image
    @city = location.city
    @state = location.state
    @weather_icon = forecast.currently.icon
    photos = flickr.photos.search(:text => "#{@city} #{@state}", :sort => "relevance", :per_page => 5, :page => 1)
    id     = photos[1].id
    secret = photos[1].secret
    info = flickr.photos.getInfo(:photo_id => id, :secret => secret)
    sizes = flickr.photos.getSizes(:photo_id => id)
    original = sizes.find {|s| s.label == 'Large' }

    @url = original.source
  end
end
