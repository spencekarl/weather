class WeatherController < ApplicationController
  def index
    latitude, longitude = request.location.latitude, request.location.longitude

    location = Geocoder.search("#{latitude},#{longitude}").first
    @city = location.city
    @state = location.state

    forecast = ForecastIO.forecast(latitude, longitude)
    @weather_icon = forecast.currently.icon
    @temperature = forecast.currently.temperature.to_i

    tags = "outdoor,outdoors,outside,landscape"

    case @weather_icon
    when "clear-night" || "partly-cloudy-night"
      tags.prepend("night,")
    when "cloudy"
      tags.prepend("cloudy,")
    when "rain" || "sleet"
      tags.prepend("rain,rainy,")
    when "snow"
      tags.prepend("snow,snowy,")
    when "fog"
      tags.prepend("fog,foggy,")
    else
      tags.prepend("sunny,")
    end

    photo_results = flickr.photos.search(:text => "#{@city} #{@state}", :sort => "relevance",
                                  :safe_search => 1, :content_type => 1, :per_page => 10, :page => 1, :tags => tags, :extras => "url_k, url_h")
    if photo_results[0] == nil
      photo_results = flickr.photos.search(:text => "#{@city} #{@state}", :sort => "relevance",
                                    :safe_search => 1, :content_type => 1, :per_page => 10, :page => 1, :extras => "url_k, url_h")
    end

    url_list = []
    photo_results.each { |photo| url_list.push(photo.url_k) if photo.respond_to?(:url_k) }

    @location_photo = url_list[rand(url_list.length)]

    # next up: full screen image, and stlye weather
    # learn about scss
    #          refactor, validate existence of large
    #          refine search to get better results
    #          deploy to heroku to test
    #          figure out better way to geocode
    #          rename variables and decide need for
  end
end
