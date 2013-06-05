require 'cinch'
require 'ostruct'
require 'open-uri'
require 'json'

module Cinch
  module Plugins
    class Forecast
      include Cinch::Plugin

      API_KEY  = ENV['WUNDERGROUND_KEY']
      BASE_URL = "http://api.wunderground.com/api/#{API_KEY}/"


      match /forecast (.+)/

      attr_accessor :location, :conditions

      def execute(m, query)
        @location, @conditions = nil, {}

        geolookup(query)
        get_conditions

        ##
        # Reply with the Weather Summary
        m.reply(weather_summary)
      end

      def geolookup(zipcode)
        results = open("#{BASE_URL}geolookup/q/#{zipcode}.json").read
        data = JSON.parse(results)
        @location = data['location']['l']
      rescue
        "No results found for #{zipcode}"
      end

      def get_conditions
        results = open("#{BASE_URL}conditions#{@location}.json").read

        ##
        # Cleanup and store into Hash
        clean_up(JSON.parse(results))
      rescue
        'No weather data was found.'
      end

      def clean_up(data)
        ##
        # County, State & Country
        @conditions.store(:county, data['current_observation']['display_location']['full'])
        @conditions.store(:country, data['current_observation']['display_location']['country'])

        ##
        # Latitude and Longitude
        @conditions.store(:lat, data['current_observation']['display_location']['latitude'])
        @conditions.store(:lng, data['current_observation']['display_location']['longitude'])

        ##
        # Observation Time
        @conditions.store(:observation_time, data['current_observation']['observation_time'])

        ##
        # General Weather Information
        @conditions.store(:weather, data['current_observation']['weather'])
        @conditions.store(:temp_fahrenheit, data['current_observation']['temp_f'])
        @conditions.store(:temp_celcius, data['current_observation']['temp_c'])
        @conditions.store(:relative_humidity, data['current_observation']['relative_humidity'])
        @conditions.store(:feels_like, data['current_observation']['feelslike_string'])
        @conditions.store(:uv, data['current_observation']['UV'])

        ##
        # Wind Related Data
        @conditions.store(:wind, data['current_observation']['wind_string'])
        @conditions.store(:wind_direction, data['current_observation']['wind_dir'])
        @conditions.store(:wind_degrees, data['current_observation']['wind_degrees'])
        @conditions.store(:wind_mph, data['current_observation']['wind_mph'])
        @conditions.store(:wind_gust_mph, data['current_observation']['wind_gust_mph'])
        @conditions.store(:wind_kph, data['current_observation']['wind_kph'])
        @conditions.store(:pressure_mb, data['current_observation']['pressure_mb'])

        ##
        # Forecast URL
        @conditions.store(:forecast_url, data['current_observation']['forecast_url'])
        @conditions.store(:fetched_from, "#{BASE_URL}conditions#{@location}.json")

        @conditions = OpenStruct.new(@conditions)
      rescue
        'Problem getting data.'
      end

      def weather_summary
        ##
        # Sample Summary using geolookup('00687')
        # Weather for: Morovis, PR, US
        # Party Cloudy, feels like 85 F (27.1 C)
        # UV: 9.5, Humidity: 78%
        # Wind: From the SE at 1.0 MPH Gusting to 5.0 MPH
        # Direction: East, Degrees: 90
        # Last Updated on June 4, 11:25 PM AST
        # More Info: http://www.wunderground.com/US/PR/Morovis.html

        %Q{Weather for: #{@conditions.county}, #{@conditions.country}
        #{@conditions.weather}, #{@conditions.feels_like}
        UV: #{@conditions.uv}, Humidity: #{@conditions.relative_humidity}
        Wind: #{@conditions.wind}
        Direction: #{@conditions.wind_direction}, Degrees: #{@conditions.wind_degrees},
        #{@conditions.observation_time}
        More Info: #{@conditions.forecast_url}}
      rescue
        'Problem fetching the weather summary.'
      end
    end
  end
end