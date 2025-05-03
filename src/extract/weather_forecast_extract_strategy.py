import requests
from extract.abstract_extract_strategy import GetDataStrategy
from extract.geo_extract_strategy import GeoDirectDataStrategy


class WeatherCurrentForecastDataStrategy(GetDataStrategy):

    @property
    def __name__(self):
        return type(self).__name__

    def get_data(self, **kwargs):
        city, api_key, forecast_days = kwargs.get('city'), kwargs.get('api_key'), kwargs.get('forecast_days')
        if forecast_days > 16:
            raise Exception("Forecasts longer than 16 days are not supported.")

        lat, lon = GeoDirectDataStrategy.get_lat_and_lon(city=city, api_key=api_key)
        weather_url = f'https://api.openweathermap.org/data/2.5/forecast/daily?lat={lat}&lon={lon}&cnt={forecast_days}&appid={api_key}'
        print(weather_url)
        weather_data = requests.get(weather_url).json()

        return weather_data