from abc import ABC, abstractmethod

class GetDataStrategy(ABC):
    @abstractmethod
    def get_data(self, city, api_key, start_date, end_date, forecast_days):
        pass

    def get_data_schema(self, data):
        lvl = list(data.keys())
        txt = ''

        def get_dict_struct(name, dictionary, level):
            indentation_minus_1 = (level - 1) * '\t'
            indentation = level * '\t'
            result = f'{indentation_minus_1}{name} - dict\n'
            keys = dictionary.keys()
            for k in keys:
                key_type = type(dictionary[k])
                if key_type is dict:
                    result += get_dict_struct(k, dictionary[k], level + 1)
                elif key_type is list:
                    if k is not None:
                        result += get_list_struct(k, dictionary[k], level + 1)
                    else:
                        result += get_list_struct('nameless list', dictionary[k], level + 1)
                else:
                    result += f'{indentation}{k} - {key_type.__name__}\n'
            return result

        def get_list_struct(name, lis, level):
            indentation_minus_1 = (level - 1) * '\t'
            indentation = level * '\t'
            result = f'{indentation_minus_1}{name} - list\n'
            for k in lis:
                key_type = type(k)
                if key_type is dict:
                    result += get_dict_struct(name, k, level + 1)
                elif key_type is list:
                    result += get_list_struct(name, k, level + 1)
                else:
                    result += f'{indentation}{k} - {key_type.__name__}\n'
            return result

        for key in lvl:
            tp = type(data[key])
            if tp is dict:
                txt += get_dict_struct(key, data[key], 1)
            elif tp is list:
                txt += get_list_struct(key, data[key], 1)
            else:
                txt += f'{key} - {tp.__name__}\n'

        return txt

    def print_schema(self, data):
        print(self.get_data_schema(data))