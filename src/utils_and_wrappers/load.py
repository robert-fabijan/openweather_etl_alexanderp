from load.abstract_load_strategy import LoadDataStrategy

class Load:
    id_list = []

    def __init__(self, data, target_table, load_strategy: LoadDataStrategy):
        self.load_strategy = load_strategy
        self.data = data
        self.target_table = target_table

        self.id = 0 if len(Load.id_list) == 0 else max(Load.id_list) + 1
        Load.id_list.append(self.id)

    def load_to_bigquery(self):
        data = self.data
        for city in data.keys():
            self.load_strategy.load_data_to_bigquery(self.data[city], 'totemic-client-447220-r1.openweather_etl.weather')

    def load_raw_to_bigquery(self, data_format='dict'):
        data = self.data
        for city in data.keys():
            self.load_strategy.load_data_to_bigquery(self.data[city], self.target_table, data_format)