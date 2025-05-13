import os
import base64
import json
import functions_framework
import pandas as pd
from dotenv import load_dotenv

from src.extract.pollution_extract_strategy import AirPollutionDataStrategy, AirPollutionHistoryDataStrategy
from src.utils_and_wrappers.utils import publish_message
from src.utils_and_wrappers.endpoint import Endpoint


load_dotenv()
API_KEY = os.getenv('OPEN_WEATHER_API_KEY')

@functions_framework.http
def get_pollution_data(_):
    app_weather = Endpoint(AirPollutionDataStrategy())
    app_weather.append_data_from_cities(API_KEY)
    gathered_data = app_weather.return_all_data()

    result = json.dumps(gathered_data)
    return result, 200

@functions_framework.http
def get_historical_pollution_data(request):
    request_args = request.args
    if request_args and 'start_date' in request_args and 'end_date' in request_args:
        start_date = request_args['start_date']
        end_date = request_args['end_date']
    else:
        return 'End date or start date not provided', 400

    app_weather = Endpoint(AirPollutionHistoryDataStrategy())
    app_weather.append_data_from_cities(api_key=API_KEY, start_date=start_date, end_date=end_date)
    gathered_data = app_weather.return_all_data()

    result = json.dumps(gathered_data)
    publish_message(result, historical_pollution_pubsub_topic)
    print("message published!")
    return result, 200

