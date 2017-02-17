# Europeana API

[![Build Status](https://travis-ci.org/europeana/europeana-api-client-ruby.svg?branch=develop)](https://travis-ci.org/europeana/europeana-api-client-ruby) [![Coverage Status](https://coveralls.io/repos/europeana/europeana-api-client-ruby/badge.svg?branch=develop&service=github)](https://coveralls.io/github/europeana/europeana-api-client-ruby?branch=develop) [![security](https://hakiri.io/github/europeana/europeana-api-client-ruby/develop.svg)](https://hakiri.io/github/europeana/europeana-api-client-ruby/develop) [![Dependency Status](https://gemnasium.com/europeana/europeana-api-client-ruby.svg)](https://gemnasium.com/europeana/europeana-api-client-ruby)

Ruby client library for the search and retrieval of records from the [Europeana
REST API](http://labs.europeana.eu/api/introduction/).

## Requirements

* Ruby >= 2.2.2

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'europeana-api'
```

And then execute:

```
bundle
```

Or install it yourself as:

```
gem install europeana-api
```

## Usage

### Authentication

Authentication by API key is *required* for all requests to the Europeana API.

Sign up for an API key at: http://labs.europeana.eu/api/registration/

Configure your application with the API key:

```ruby
require 'europeana/api'
Europeana::API.key = 'xyz'
```

### Response format

Responses from the API methods described below will by default be hashes with
indifferent access, i.e. values can be retrieved by string or symbol keys.

To have API methods return objects instead:
```ruby
Europeana::API.configure do |config|
  config.parse_json_to = OpenStruct
end
```

### Records

#### Search

```ruby
search = Europeana::API.record.search(query: '"first world war"')
search[:items] # => [ item1, item2, ... ]
search[:totalResults] # => 81530
```

See http://labs.europeana.eu/api/search/ for details of the available request
parameters, and of the data returned in the search response.

#### Fetch

```ruby
record = Europeana::API.record.fetch(id: '/92070/BibliographicResource_1000126223918')
record[:object][:title] # => ["Panorama des Schafberges in Ober-Österreich. Blatt 1"]
record[:object][:proxies].first[:dcCreator][:def] # => ["Simony, Friedrich"]
```

See http://labs.europeana.eu/api/record/ for details of the data returned in
the record response.

#### Hierarchies

```ruby
hierarchy = Europeana::API.record.parent(id: '/2048604/data_item_onb_abo__2BZ17084070X')
hierarchy[:parent][:id] # => "/2048604/data_item_onb_abo_AC10352829"
```

Methods available for hierarchy retrieval:
```ruby
Europeana::API.record.self
Europeana::API.record.parent
Europeana::API.record.children
Europeana::API.record.preceding_siblings
Europeana::API.record.following_siblings
Europeana::API.record.ancestor_self_siblings
```

See http://labs.europeana.eu/api/hierarchical-records for details of the various
hierarchy methods and their responses.

### Annotations

See http://labs.europeana.eu/api/annotations-methods for details of the responses
received from the Annotations API methods.

*NB:* at present, this API client only supports search and fetch of annotations.

#### Search

```ruby
search = Europeana::API.annotation.search(query: 'music')
search[:items].first # => "http://data.europeana.eu/annotation/collections/8"
```

#### Fetch

```ruby
annotation = Europeana::API.annotation.fetch(provider: 'collections', id: 8)
annotation[:body] # => "Sheet music"
```

## License

Licensed under the EUPL V.1.1.

For full details, see [LICENSE.md](LICENSE.md).
