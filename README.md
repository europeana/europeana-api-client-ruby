# Europeana

Ruby client library for the search and retrieval of records from the [Europeana
REST API](http://labs.europeana.eu/api/introduction/).

## Installation

Add this line to your application's Gemfile:

    gem 'europeana'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install europeana

## Usage

### Authentication

Authentication is *required* for all requests to the Europeana API.

Only Basic Authentication (by API key) is supported. 

Sign up for an API key at: http://labs.europeana.eu/api/registration/

Configure your application with the API key:

    Europeana.api_key = "xyz"

### Search

    search = Europeana.search(:query => '"first world war"') # => { "success" => true, "items2 => [ ... ], "totalResults" => 1234, ... }
    search["items"] # => [ item1, item2, ... ]
    search["totalResults"] # => 1234
    
See http://labs.europeana.eu/api/search/ for details of the data returned in
the search response.

### Record

    record = Europeana.record("abc/1234") # => { "success" => true, "object" => { ... }, ... }
    record["object"] # => { "title" => "...", "proxies" => [ ... ], "aggregations" => [ ... ]

See http://labs.europeana.eu/api/record/ for details of the data returned in
the record response.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
