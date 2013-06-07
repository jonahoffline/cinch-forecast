[![Gem Version](https://badge.fury.io/rb/cinch-forecast.png)](http://badge.fury.io/rb/cinch-forecast)
[![Dependency Status](https://gemnasium.com/jonahoffline/cinch-forecast.png)](https://gemnasium.com/jonahoffline/cinch-forecast)

Cinch::Forecast
=================

Forecast is a Cinch plugin for getting the weather forecast.

Installation
---------------------

    $ gem install cinch-forecast

Setup
-------

You will need a Wunderground API key. You can sign-up for a free one at
[Wunderground](http://www.wunderground.com/weather/api/)

#### Configuration ####

Set your key as an environment variable:

    $ export WUNDERGROUND_KEY='your_api_key_here'

You could also save it in your ~/.bash_profile

#### Command ####

  * !forecast [zipcode]    - Fetches the weather forecast for zipcode.

## Integration with Cinch ##

```ruby
require 'cinch'
require 'cinch/plugins/forecast'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'irc.freenode.net'
    c.nick   = 'Tavin_Pumarejo'
    c.channels = ['#RubyOnADHD']
    c.plugins.plugins = [Cinch::Plugins::Forecast]
  end
end

bot.start
```

Enjoy!

## Author
  * [Jonah Ruiz](http://www.pixelhipsters.com)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
