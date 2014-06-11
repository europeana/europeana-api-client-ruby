# Europeana

Search and retrieve records from the Europeana portal API.

## Installation

Add this line to your application's Gemfile:

    gem 'europeana'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install europeana

## Usage

### Authentication

Only Basic Authentication (by API key) is supported. 

Sign up for an API key at: http://labs.europeana.eu/api/registration/

Configure your application with the API key:

    Europeana.api_key = "xyz"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
