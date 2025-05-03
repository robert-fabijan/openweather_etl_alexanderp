import requests
from extract.abstract_extract_strategy import GetDataStrategy
from extract.geo_extract_strategy import GeoDirectDataStrategy
from utils_and_wrappers.utils import string_data_to_timestamp_unix

class WeatherHistoryDataStrategy(GetDataStrategy):

    @property
    def __name__(self):
        return type(self).__name__

    def get_data(self, **kwargs):
        city, api_key, start_date, end_date = kwargs.get('city'), kwargs.get('api_key'), kwargs.get('start_date'), kwargs.get('end_date')
        lat, lon = GeoDirectDataStrategy.get_lat_and_lon(city=city, api_key=api_key)
        end_date = string_data_to_timestamp_unix(end_date)
        start_date = string_data_to_timestamp_unix(start_date)
        pollution_url = f'https://history.openweathermap.org/data/2.5/history/city?lat={lat}&lon={lon}&type=hour&start={start_date}&end={end_date}&appid={api_key}'
        pollution_data = requests.get(pollution_url).json()
        return pollution_data