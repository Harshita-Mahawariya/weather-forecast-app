require 'rails_helper'

RSpec.describe "Forecasts", type: :request do
  describe "POST /forecast" do
    let(:address) { "Pithampur, India" }

    let(:location_double) do
      double("Location", address: address, latitude: 22.7196, longitude: 75.8577)
    end

    before do
      allow(Geocoder).to receive(:search).with(address).and_return([location_double])
      allow(WeatherService).to receive(:get_by_coordinates).and_return([
       {"coord":{"lon":75.7015,"lat":22.5533},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"base":"stations","main":{"temp":40.5,"feels_like":39.16,"temp_min":40.5,"temp_max":40.5,"pressure":999,"humidity":17,"sea_level":999,"grnd_level":935},"visibility":10000,"wind":{"speed":6.23,"deg":303,"gust":6.32},"clouds":{"all":97},"dt":1749553275,"sys":{"country":"IN","sunrise":1749514327,"sunset":1749562880},"timezone":19800,"id":7279595,"name":"Pithampur","cod":200},
        false
      ])
    end

    it "returns http success" do
      post "/forecast", params: { address: address }
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Pithampur, India")
      expect(response.body).to include("30.0°C")
    end
  end
end
