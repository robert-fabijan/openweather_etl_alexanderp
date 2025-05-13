import os
import base64
import json
import functions_framework
import pandas as pd
from dotenv import load_dotenv

from src.extract.pollution_extract_strategy import WeatherCurrentDataStrategy
from src.utils_and_wrappers.endpoint import Endpoint

load_dotenv()
API_KEY = os.getenv('OPEN_WEATHER_API_KEY')

@functions_framework.http
def get_weather_data(_):
    app_weather = Endpoint(WeatherCurrentDataStrategy())
    app_weather.append_data_from_cities(API_KEY)
    gathered_data = app_weather.return_all_data()

    result = json.dumps(gathered_data)
    return result, 200