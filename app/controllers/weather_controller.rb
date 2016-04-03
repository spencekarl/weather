class WeatherController < ApplicationController
  def index
    # Stores all location and necessary weather data
    latitude, longitude = request.location.latitude, request.location.longitude
    location = Geocoder.search("#{latitude},#{longitude}").first
    @city, @state = location.city, location.state
    forecast = ForecastIO.forecast(latitude, longitude)
    @weather_icon, @temperature = forecast.currently.icon, forecast.currently.temperature.to_i

    # Search for photos at location
    search_params = {:text => "#{@city} #{@state}", :sort => "relevance", :safe_search => 1, :content_type => 1,
                     :per_page => 10, :page => 1, :tags => "get_tags", :extras => "url_k, url_h"}
    photo_results = flickr.photos.search(search_params)

    # Have to re-do search if no photo tags exist
    if photo_results[0] == nil
      search_params[:tags] = ""
      photo_results = flickr.photos.search(search_params)
    end

    # Build list of potential photos to choose from and pick at random
    url_list = []
    photo_results.each { |photo| url_list.push(photo.url_k) if photo.respond_to?(:url_k) }
    @location_photo = url_list[rand(url_list.length)]
  end

  private

  # Build a string of photo tags based on the weather
  def get_tags
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
      tags.prepend("sun,sunny,")
    end
  end
end
