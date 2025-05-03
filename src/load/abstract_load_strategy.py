from abc import ABC, abstractmethod
from google.cloud import bigquery

class LoadDataStrategy(ABC):

    @abstractmethod
    def dummy_load(self, data, table_name):
        pass

    def load_data_to_bigquery(self, data, table_name, data_format):
        ### just for one city; function assumes that data is just a dict for one city
        #data = json.dumps(data)
        client = bigquery.Client()

        if data_format == 'dict':
            errors = client.insert_rows_json(
                table_name, [data]
            )
            if not errors:
                print("Rows have been added.")
            else:
                print("Encountered errors while inserting rows: {}".format(errors))
        elif data_format == 'dataframe':
            job_config = bigquery.LoadJobConfig(
                write_disposition=bigquery.WriteDisposition.WRITE_APPEND
            )
            job = client.load_table_from_dataframe(data, table_name, job_config=job_config)
            job.result()
            print(f"Loaded {job.output_rows} into {table_name}")
        else:
            print('Incorrect data format. Currently available data formats: dict, dataframe')