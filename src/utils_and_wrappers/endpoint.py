from extract.abstract_extract_strategy import GetDataStrategy
from utils_and_wrappers.utils import get_cities_from_config
import asyncio

class Endpoint:
    id_list = []

    def __init__(self, extract_strategy: GetDataStrategy):
        self.extract_strategy = extract_strategy
        self.collected_data = dict()
        self.id = 0 if len(Endpoint.id_list) == 0 else max(Endpoint.id_list) + 1
        Endpoint.id_list.append(self.id)

    def print_data(self, city):
        print(self.collected_data[city])

    def print_all_data(self):
        print(self.collected_data)

    def return_data(self, city):
        return self.collected_data[city]

    def return_all_data(self):
        return self.collected_data

    def append_data_from_cities(self, api_key, start_date=0, end_date=0, forecast_days=0):

        cities = get_cities_from_config()
        if len(cities) < 1:
            raise Exception('The "cities" list should not be empty')

        async def async_get_city_data(city_name):
            data = self.extract_strategy.get_data(city=city_name, api_key=api_key, start_date=start_date, end_date=end_date, forecast_days=forecast_days)
            self.collected_data[city_name] = data
            return 1

        async def gather_data():
            tasks = [async_get_city_data(city) for city in cities]
            results = await asyncio.gather(*tasks)
            return results

        asyncio.run(gather_data())

    def print_data_schema(self):
        self.extract_strategy.print_schema(self.collected_data)