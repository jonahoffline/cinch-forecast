require 'cinch'
require 'ostruct'
require 'open-uri'
require 'json'

module Cinch
  module Plugins
    class Forecast
      include Cinch::Plugin

      match /forecast (.+)/
      def execute(m, query)
        ##
        # Gets location using zipcode
        location = geolookup(query)
        return m.reply "No results found for #{query}." if location.nil?

        ##
        # Gets the weather conditions
        data = get_conditions(location)
        return m.reply 'Problem getting data. Try again later.' if data.nil?

        ##
        # Returns the weather summary
        m.reply(weather_summary(data))
      end

      def geolookup(zipcode)
        location = JSON.parse(open("http://api.wunderground.com/api/#{ENV['WUNDERGROUND_KEY']}/geolookup/q/#{zipcode}.json").read)
        location['location']['l']
      rescue
        nil
      end

      def get_conditions(location)
        data = JSON.parse(open("http://api.wunderground.com/api/#{ENV['WUNDERGROUND_KEY']}/conditions#{location}.json").read)

        ##
        # Clean up and return as an OpenStruct
        OpenStruct.new(
            ##
            # County, State & Country
            county: data['current_observation']['display_location']['full'],
            country: data['current_observation']['display_location']['country'],

            ##
            # Latitude and Longitude
            lat: data['current_observation']['display_location']['latitude'],
            lng: data['current_observation']['display_location']['longitude'],

            ##
            # Observation Time and General Weather Information
            observation_time: data['current_observation']['observation_time'],
            weather: data['current_observation']['weather'],
            temp_fahrenheit: data['current_observation']['temp_f'],
            temp_celcius: data['current_observation']['temp_c'],
            relative_humidity: data['current_observation']['relative_humidity'],
            feels_like: data['current_observation']['feelslike_string'],
            uv: data['current_observation']['UV'],

            ##
            # Wind Related Data
            wind: data['current_observation']['wind_string'],
            wind_direction: data['current_observation']['wind_dir'],
            wind_degrees: data['current_observation']['wind_degrees'],
            wind_mph: data['current_observation']['wind_mph'],
            wind_gust_mph: data['current_observation']['wind_gust_mph'],
            wind_kph: data['current_observation']['wind_kph'],
            pressure_mb: data['current_observation']['pressure_mb'],

            ##
            # Forecast URL
            forecast_url: data['current_observation']['forecast_url']
        )
      rescue
        nil
      end

      def weather_summary(data)
        ##
        # Sample Summary using !forecast 00687
        # Forecast for: Morovis, PR, US
        # Latitude: 18.32682228, Longitude: -66.40519714
        # Weather is Partly Cloudy, feels like 85 F (27.1 C)
        # UV: 9.5, Humidity: 78%
        # Wind: From the SE at 1.0 MPH Gusting to 5.0 MPH
        # Direction: East, Degrees: 90
        # Last Updated on June 4, 11:25 PM AST
        # More Info: http://www.wunderground.com/US/PR/Morovis.html

        %Q{
          Forecast for: #{data.county}, #{data.country}
          Latitude: #{data.lat}, Longitude: #{data.lng}
          Weather is #{data.weather}, #{data.feels_like}
          UV: #{data.uv}, Humidity: #{data.relative_humidity}
          Wind: #{data.wind}
          Direction: #{data.wind_direction}, Degrees: #{data.wind_degrees},
          #{data.observation_time}
          More Info: #{data.forecast_url}}
      rescue
        'Problem fetching the weather summary. Try again later.'
      end
    end
  end
end