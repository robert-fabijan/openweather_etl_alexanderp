from load.abstract_load_strategy import LoadDataStrategy
from google.cloud import bigquery


class GeoLoadStrategy(LoadDataStrategy):

    def dummy_load(self, data, table_name):
        pass

    def load_data_to_bigquery(self, data, table_name, data_format):
        ### just for one city; function assumes that data is just a dict for one city
        #data = json.dumps(data)
        client = bigquery.Client()

        errors = client.insert_rows_json(
            table_name, data
        )
        if not errors:
            print("Rows have been added.")
        else:
            print("Encountered errors while inserting rows: {}".format(errors))