from load.abstract_load_strategy import LoadDataStrategy
from google.cloud import bigquery

class WeatherLoadStrategy(LoadDataStrategy):

    def dummy_load(self, data, table_name):
        pass

    def load_temperatue_to_bigquery(self, data, table_name):
        insert_values=[]
        for city in data.keys():
            text = f"('{data[city][0]}', '{city}', {data[city][1]})"
            insert_values.append(text)

        merged_values = ", ".join(insert_values)
        full_insert = f"""INSERT INTO `{table_name}` (ds, City, Temperature) VALUES {merged_values};"""

        try:
            client = bigquery.Client()
            job = client.query(full_insert)
            job.result()
            print("Insert successful.")
        except Exception as e:
            print(f'Error occurred during data insert: {e}')