# Europeana

[![Build Status](https://travis-ci.org/europeana/europeana-api-client-ruby.svg?branch=master)](https://travis-ci.org/europeana/europeana-api-client-ruby) [![Coverage Status](https://coveralls.io/repos/europeana/europeana-api-client-ruby/badge.svg?branch=master&service=github)](https://coveralls.io/github/europeana/europeana-api-client-ruby?branch=master) [![security](https://hakiri.io/github/europeana/europeana-api-client-ruby/master.svg)](https://hakiri.io/github/europeana/europeana-api-client-ruby/master) [![Dependency Status](https://gemnasium.com/europeana/europeana-api-client-ruby.svg)](https://gemnasium.com/europeana/europeana-api-client-ruby)

Ruby client library for the search and retrieval of records from the [Europeana
REST API](http://labs.europeana.eu/api/introduction/).

## License

Licensed under the EUPL V.1.1.

For full details, see [LICENSE.md](LICENSE.md).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'europeana-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install europeana-api

## Usage

### Authentication

Authentication is *required* for all requests to the Europeana API.

Only Basic Authentication (by API key) is supported.

Sign up for an API key at: http://labs.europeana.eu/api/registration/

Configure your application with the API key:

```ruby
require 'europeana/api'
Europeana::API.key = 'xyz'
```

### Record search

```ruby
search = Europeana::Record.search(query: '"first world war"')
search.items # => [ item1, item2 ]
search.totalResults # => 1234
```

See http://labs.europeana.eu/api/search/ for details of the data returned in
the search response.

### Record retrieval

```ruby
record = Europeana::Record.fetch(id: '/abc/1234')
record.title # => ["The title of this Europeana record"]
record.proxies.first.dcType.en # => ["The dcType of the record's first proxy"]
```

See http://labs.europeana.eu/api/record/ for details of the data returned in
the record response.
