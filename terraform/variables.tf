variable "project_id" {
  type=string
  description="Google Cloud project id"
}
variable "region" {
  type=string
  description="Google Cloud region"
  default="europe-central2"
}
variable "gcp_credentials" {
  type=string
  description="Google Cloud credentials in json format"
  sensitive=true
}
variable "open_weather_api_key" {
  description = "API key for OpenWeather"
  type        = string
  sensitive   = true
}
variable "functions_source_dir" {
  description = "path to source code functions"
  type        = string
  default     = "../cloud_functions"
}
variable "extract_functions" {
  type = list(string)
  description = "List of the extraction functions to export"
  default = ["get_geo_data", "get_pollution_data", "get_weather_data"]
}
variable "bq_weather_schema" {
  type = any
  description = "Schema for BigQuery table that contains raw weather data"
  default = [
    {
      name = "coord"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "lon", type = "FLOAT", mode = "NULLABLE" },
        { name = "lat", type = "FLOAT", mode = "NULLABLE" }
      ]
    },
    {
      name = "weather"
      type = "RECORD"
      mode = "REPEATED"
      fields = [
        { name = "id", type = "INTEGER", mode = "NULLABLE" },
        { name = "main", type = "STRING", mode = "NULLABLE" },
        { name = "description", type = "STRING", mode = "NULLABLE" },
        { name = "icon", type = "STRING", mode = "NULLABLE" }
      ]
    },
    {
      name = "base"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "main"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "temp", type = "FLOAT", mode = "NULLABLE" },
        { name = "feels_like", type = "FLOAT", mode = "NULLABLE" },
        { name = "temp_min", type = "FLOAT", mode = "NULLABLE" },
        { name = "temp_max", type = "FLOAT", mode = "NULLABLE" },
        { name = "pressure", type = "INTEGER", mode = "NULLABLE" },
        { name = "humidity", type = "INTEGER", mode = "NULLABLE" },
        { name = "sea_level", type = "INTEGER", mode = "NULLABLE" },
        { name = "grnd_level", type = "INTEGER", mode = "NULLABLE" }
      ]
    },
    {
      name = "visibility"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "wind"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "speed", type = "FLOAT", mode = "NULLABLE" },
        { name = "deg", type = "INTEGER", mode = "NULLABLE" },
        { name = "gust", type = "FLOAT", mode = "NULLABLE" }
      ]
    },
    {
      name = "clouds"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "all", type = "INTEGER", mode = "NULLABLE" }
      ]
    },
    {
      name = "dt"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "sys"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "type", type = "INTEGER", mode = "NULLABLE" },
        { name = "id", type = "INTEGER", mode = "NULLABLE" },
        { name = "country", type = "STRING", mode = "NULLABLE" },
        { name = "sunrise", type = "INTEGER", mode = "NULLABLE" },
        { name = "sunset", type = "INTEGER", mode = "NULLABLE" }
      ]
    },
    {
      name = "timezone"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "id"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "name"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "cod"
      type = "INTEGER"
      mode = "NULLABLE"
    }
  ]
}
variable "bq_pollution_schema" {
  type = any
  description = "Schema for BigQuery table that contains raw pollution data"
  default = [
    {
      name = "coord"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        {
          name = "lon"
          type = "FLOAT"
          mode = "NULLABLE"
        },
        {
          name = "lat"
          type = "FLOAT"
          mode = "NULLABLE"
        }
      ]
    },
    {
      name = "list"
      type = "RECORD"
      mode = "REPEATED"
      fields = [
        {
          name = "main"
          type = "RECORD"
          mode = "NULLABLE"
          fields = [
            {
              name = "aqi"
              type = "INTEGER"
              mode = "NULLABLE"
            }
          ]
        },
        {
          name = "components"
          type = "RECORD"
          mode = "NULLABLE"
          fields = [
            { name = "co", type = "FLOAT", mode = "NULLABLE" },
            { name = "no", type = "FLOAT", mode = "NULLABLE" },
            { name = "no2", type = "FLOAT", mode = "NULLABLE" },
            { name = "o3", type = "FLOAT", mode = "NULLABLE" },
            { name = "so2", type = "FLOAT", mode = "NULLABLE" },
            { name = "pm2_5", type = "FLOAT", mode = "NULLABLE" },
            { name = "pm10", type = "FLOAT", mode = "NULLABLE" },
            { name = "nh3", type = "FLOAT", mode = "NULLABLE" }
          ]
        },
        {
          name = "dt"
          type = "TIMESTAMP"
          mode = "NULLABLE"
        }
      ]
    }
  ]
}
variable "bq_geo_schema" {
  type = any
  description = "Schema for BigQuery table that contains raw geo data"
  default = [
    {
      name = "name"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "local_names"
      type = "RECORD"
      mode = "NULLABLE"
      fields = [
        { name = "it", type = "STRING", mode = "NULLABLE" },
        { name = "bo", type = "STRING", mode = "NULLABLE" },
        { name = "ar", type = "STRING", mode = "NULLABLE" },
        { name = "sc", type = "STRING", mode = "NULLABLE" },
        { name = "pt", type = "STRING", mode = "NULLABLE" },
        { name = "el", type = "STRING", mode = "NULLABLE" },
        { name = "hr", type = "STRING", mode = "NULLABLE" },
        { name = "es", type = "STRING", mode = "NULLABLE" },
        { name = "sq", type = "STRING", mode = "NULLABLE" },
        { name = "mn", type = "STRING", mode = "NULLABLE" },
        { name = "az", type = "STRING", mode = "NULLABLE" },
        { name = "wo", type = "STRING", mode = "NULLABLE" },
        { name = "eu", type = "STRING", mode = "NULLABLE" },
        { name = "af", type = "STRING", mode = "NULLABLE" },
        { name = "cv", type = "STRING", mode = "NULLABLE" },
        { name = "zh", type = "STRING", mode = "NULLABLE" },
        { name = "en", type = "STRING", mode = "NULLABLE" },
        { name = "fo", type = "STRING", mode = "NULLABLE" },
        { name = "gv", type = "STRING", mode = "NULLABLE" },
        { name = "ur", type = "STRING", mode = "NULLABLE" },
        { name = "an", type = "STRING", mode = "NULLABLE" },
        { name = "my", type = "STRING", mode = "NULLABLE" },
        { name = "ru", type = "STRING", mode = "NULLABLE" },
        { name = "am", type = "STRING", mode = "NULLABLE" },
        { name = "os", type = "STRING", mode = "NULLABLE" },
        { name = "ku", type = "STRING", mode = "NULLABLE" },
        { name = "la", type = "STRING", mode = "NULLABLE" },
        { name = "hu", type = "STRING", mode = "NULLABLE" },
        { name = "tr", type = "STRING", mode = "NULLABLE" },
        { name = "cu", type = "STRING", mode = "NULLABLE" },
        { name = "ht", type = "STRING", mode = "NULLABLE" },
        { name = "he", type = "STRING", mode = "NULLABLE" },
        { name = "nl", type = "STRING", mode = "NULLABLE" },
        { name = "zu", type = "STRING", mode = "NULLABLE" },
        { name = "kw", type = "STRING", mode = "NULLABLE" },
        { name = "ga", type = "STRING", mode = "NULLABLE" },
        { name = "gd", type = "STRING", mode = "NULLABLE" },
        { name = "jv", type = "STRING", mode = "NULLABLE" },
        { name = "uk", type = "STRING", mode = "NULLABLE" },
        { name = "na", type = "STRING", mode = "NULLABLE" },
        { name = "et", type = "STRING", mode = "NULLABLE" },
        { name = "nn", type = "STRING", mode = "NULLABLE" },
        { name = "de", type = "STRING", mode = "NULLABLE" },
        { name = "ba", type = "STRING", mode = "NULLABLE" },
        { name = "kk", type = "STRING", mode = "NULLABLE" },
        { name = "th", type = "STRING", mode = "NULLABLE" },
        { name = "ca", type = "STRING", mode = "NULLABLE" },
        { name = "ka", type = "STRING", mode = "NULLABLE" },
        { name = "ak", type = "STRING", mode = "NULLABLE" },
        { name = "fy", type = "STRING", mode = "NULLABLE" },
        { name = "st", type = "STRING", mode = "NULLABLE" },
        { name = "ro", type = "STRING", mode = "NULLABLE" },
        { name = "mg", type = "STRING", mode = "NULLABLE" },
        { name = "bg", type = "STRING", mode = "NULLABLE" },
        { name = "sv", type = "STRING", mode = "NULLABLE" },
        { name = "ug", type = "STRING", mode = "NULLABLE" },
        { name = "sk", type = "STRING", mode = "NULLABLE" },
        { name = "da", type = "STRING", mode = "NULLABLE" },
        { name = "is", type = "STRING", mode = "NULLABLE" },
        { name = "ia", type = "STRING", mode = "NULLABLE" },
        { name = "pl", type = "STRING", mode = "NULLABLE" },
        { name = "eo", type = "STRING", mode = "NULLABLE" },
        { name = "tt", type = "STRING", mode = "NULLABLE" },
        { name = "mk", type = "STRING", mode = "NULLABLE" },
        { name = "gl", type = "STRING", mode = "NULLABLE" },
        { name = "tg", type = "STRING", mode = "NULLABLE" },
        { name = "ko", type = "STRING", mode = "NULLABLE" },
        { name = "cs", type = "STRING", mode = "NULLABLE" },
        { name = "bi", type = "STRING", mode = "NULLABLE" },
        { name = "rm", type = "STRING", mode = "NULLABLE" },
        { name = "sw", type = "STRING", mode = "NULLABLE" },
        { name = "uz", type = "STRING", mode = "NULLABLE" },
        { name = "kl", type = "STRING", mode = "NULLABLE" },
        { name = "io", type = "STRING", mode = "NULLABLE" },
        { name = "no", type = "STRING", mode = "NULLABLE" },
        { name = "kn", type = "STRING", mode = "NULLABLE" },
        { name = "ky", type = "STRING", mode = "NULLABLE" },
        { name = "ms", type = "STRING", mode = "NULLABLE" },
        { name = "bn", type = "STRING", mode = "NULLABLE" },
        { name = "ja", type = "STRING", mode = "NULLABLE" },
        { name = "ab", type = "STRING", mode = "NULLABLE" },
        { name = "ln", type = "STRING", mode = "NULLABLE" },
        { name = "mr", type = "STRING", mode = "NULLABLE" },
        { name = "hy", type = "STRING", mode = "NULLABLE" },
        { name = "lv", type = "STRING", mode = "NULLABLE" },
        { name = "be", type = "STRING", mode = "NULLABLE" },
        { name = "ta", type = "STRING", mode = "NULLABLE" },
        { name = "ie", type = "STRING", mode = "NULLABLE" },
        { name = "sh", type = "STRING", mode = "NULLABLE" },
        { name = "mt", type = "STRING", mode = "NULLABLE" },
        { name = "sl", type = "STRING", mode = "NULLABLE" },
        { name = "tl", type = "STRING", mode = "NULLABLE" },
        { name = "id", type = "STRING", mode = "NULLABLE" },
        { name = "yi", type = "STRING", mode = "NULLABLE" },
        { name = "fa", type = "STRING", mode = "NULLABLE" },
        { name = "lb", type = "STRING", mode = "NULLABLE" },
        { name = "lt", type = "STRING", mode = "NULLABLE" },
        { name = "oc", type = "STRING", mode = "NULLABLE" },
        { name = "mi", type = "STRING", mode = "NULLABLE" },
        { name = "ee", type = "STRING", mode = "NULLABLE" },
        { name = "sr", type = "STRING", mode = "NULLABLE" },
        { name = "vi", type = "STRING", mode = "NULLABLE" },
        { name = "pa", type = "STRING", mode = "NULLABLE" },
        { name = "fi", type = "STRING", mode = "NULLABLE" },
        { name = "hi", type = "STRING", mode = "NULLABLE" },
        { name = "fr", type = "STRING", mode = "NULLABLE" },
        { name = "br", type = "STRING", mode = "NULLABLE" },
        { name = "bs", type = "STRING", mode = "NULLABLE" },
        { name = "ml", type = "STRING", mode = "NULLABLE" },
        { name = "tk", type = "STRING", mode = "NULLABLE" },
        { name = "yo", type = "STRING", mode = "NULLABLE" },
        { name = "cy", type = "STRING", mode = "NULLABLE" },
        { name = "kv", type = "STRING", mode = "NULLABLE" },
        { name = "qu", type = "STRING", mode = "NULLABLE" },
        { name = "km", type = "STRING", mode = "NULLABLE" },
        { name = "ff", type = "STRING", mode = "NULLABLE" },
        { name = "te", type = "STRING", mode = "NULLABLE" },
        { name = "li", type = "STRING", mode = "NULLABLE" },
        { name = "si", type = "STRING", mode = "NULLABLE" },
        { name = "ps", type = "STRING", mode = "NULLABLE" },
        { name = "ha", type = "STRING", mode = "NULLABLE" },
        { name = "sd", type = "STRING", mode = "NULLABLE" },
        { name = "co", type = "STRING", mode = "NULLABLE" },
        { name = "om", type = "STRING", mode = "NULLABLE" },
        { name = "su", type = "STRING", mode = "NULLABLE" },
        { name = "tw", type = "STRING", mode = "NULLABLE" },
        { name = "lo", type = "STRING", mode = "NULLABLE" },
        { name = "gu", type = "STRING", mode = "NULLABLE" },
        { name = "ay", type = "STRING", mode = "NULLABLE" },
        { name = "so", type = "STRING", mode = "NULLABLE" },
        { name = "ce", type = "STRING", mode = "NULLABLE" },
        { name = "gn", type = "STRING", mode = "NULLABLE" },
        { name = "ny", type = "STRING", mode = "NULLABLE" },
        { name = "se", type = "STRING", mode = "NULLABLE" },
        { name = "or", type = "STRING", mode = "NULLABLE" },
        { name = "sm", type = "STRING", mode = "NULLABLE" },
        { name = "bm", type = "STRING", mode = "NULLABLE" },
        { name = "to", type = "STRING", mode = "NULLABLE" },
        { name = "wa", type = "STRING", mode = "NULLABLE" },
        { name = "bh", type = "STRING", mode = "NULLABLE" },
        { name = "ne", type = "STRING", mode = "NULLABLE" },
        { name = "sa", type = "STRING", mode = "NULLABLE" },
        { name = "nv", type = "STRING", mode = "NULLABLE" },
        { name = "sn", type = "STRING", mode = "NULLABLE" },
        { name = "ig", type = "STRING", mode = "NULLABLE" },
        { name = "fj", type = "STRING", mode = "NULLABLE" },
        { name = "av", type = "STRING", mode = "NULLABLE" },
        { name = "vo", type = "STRING", mode = "NULLABLE" },
        { name = "za", type = "STRING", mode = "NULLABLE" },
        { name = "iu", type = "STRING", mode = "NULLABLE" },
        { name = "xh", type = "STRING", mode = "NULLABLE" },
        { name = "ascii", type = "STRING", mode = "NULLABLE" },
        { name = "lg", type = "STRING", mode = "NULLABLE" },
        { name = "ty", type = "STRING", mode = "NULLABLE" },
        { name = "feature_name", type = "STRING", mode = "NULLABLE" }
      ]
    },
    {
      name = "lat"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "lon"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "country"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "state"
      type = "STRING"
      mode = "NULLABLE"
    }
  ]
}
variable "geo_query" {
  type=string
  description="query for geo data"
  default=<<-EOT
  SELECT
    name as city,
    ANY_VALUE(lat) as lat,
    ANY_VALUE(lon) as lon,
    ANY_VALUE(country) as country,
    ANY_VALUE(state) as state
  FROM `totemic-client-447220-r1.openweather_etl.geo_raw`
  GROUP BY name
  EOT
}
variable "weather_query" {
  type=string
  description="query for weather data"
  default=<<-EOT
WITH pre_select AS (
  SELECT
    w.*,
    g.name as city
  FROM `totemic-client-447220-r1.openweather_etl.weather_raw` w
  LEFT JOIN `totemic-client-447220-r1.openweather_etl.geo_raw` g
  ON ROUND(w.coord.lon, 2) = ROUND(g.lon, 2) AND ROUND(w.coord.lat, 2)=ROUND(g.lat, 2)
)
SELECT
  city,
  coord.lon as lon,
  coord.lat as lat,
  ROUND(main.temp - 273.15, 2) as temperature,
  ROUND(main.feels_like - 273.15, 2) as feels_like_temperature,
  ROUND(main.temp_max - 273.15, 2) as max_temperature,
  ROUND(main.temp_min - 273.15, 2) as min_temperature,
  main.humidity as humidity,
  main.pressure as pressure,
  main.grnd_level as ground_level,
  main.sea_level as sea_level,
  TIMESTAMP_SECONDS(dt) as dt
FROM pre_select
QUALIFY ROW_NUMBER() OVER (PARTITION BY city ORDER BY dt DESC) = 1
  EOT
}
variable "pollution_query" {
  type=string
  description="query for pollution data"
  default=<<-EOT
WITH pre_select AS (
  SELECT
    p.*,
    g.name as city
  FROM `totemic-client-447220-r1.openweather_etl.pollution_raw` p
  LEFT JOIN `totemic-client-447220-r1.openweather_etl.geo_raw` g
  ON ROUND(p.coord.lon, 2) = ROUND(g.lon, 2) AND ROUND(p.coord.lat, 2)=ROUND(g.lat, 2)
)
SELECT
  city,
  coord.lon,
  coord.lat,
  `list`[SAFE_OFFSET(0)].main.aqi,
  `list`[SAFE_OFFSET(0)].components.co,
  `list`[SAFE_OFFSET(0)].components.`no`,
  `list`[SAFE_OFFSET(0)].components.no2,
  `list`[SAFE_OFFSET(0)].components.o3,
  `list`[SAFE_OFFSET(0)].components.so2,
  `list`[SAFE_OFFSET(0)].components.pm2_5,
  `list`[SAFE_OFFSET(0)].components.pm10,
  `list`[SAFE_OFFSET(0)].components.nh3,
  `list`[SAFE_OFFSET(0)].dt
FROM pre_select
QUALIFY ROW_NUMBER() OVER (PARTITION BY city ORDER BY `list`[SAFE_OFFSET(0)].dt DESC) = 1
  EOT
}