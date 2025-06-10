class ForecastsController < ApplicationController
  def index; end

  def create
    address = params[:address]
    location = Geocoder.search(address).first

    if location.blank? || location.latitude.blank? || location.longitude.blank?
      flash[:alert] = "Could not geocode address"
      redirect_to root_path and return
    end

    puts "Geocoded address: #{location.address} (#{location.latitude}, #{location.longitude})"

    forecast, from_cache = WeatherService.get_by_coordinates(location.latitude, location.longitude)

    @forecast = forecast
    @from_cache = from_cache
    @location = location.address
    render :index
  end
end
