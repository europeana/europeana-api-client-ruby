# Europeana API

[![Build Status](https://travis-ci.org/europeana/europeana-api-client-ruby.svg?branch=develop)](https://travis-ci.org/europeana/europeana-api-client-ruby) [![Security](https://hakiri.io/github/europeana/europeana-api-client-ruby/develop.svg)](https://hakiri.io/github/europeana/europeana-api-client-ruby/develop) [![Maintainability](https://api.codeclimate.com/v1/badges/ee765a461fd16730c02d/maintainability)](https://codeclimate.com/github/europeana/europeana-api-client-ruby/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/ee765a461fd16730c02d/test_coverage)](https://codeclimate.com/github/europeana/europeana-api-client-ruby/test_coverage)

Ruby client library for the search and retrieval of records from the [Europeana
REST APIs](https://pro.europeana.eu/resources/apis).

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

Sign up for an API key at: https://pro.europeana.eu/get-api

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

See https://pro.europeana.eu/resources/apis/search for details of the available request
parameters, and of the data returned in the search response.

#### Fetch

```ruby
record = Europeana::API.record.fetch(id: '/92070/BibliographicResource_1000126223918')
record[:object][:title] # => ["Panorama des Schafberges in Ober-Österreich. Blatt 1"]
record[:object][:proxies].first[:dcCreator][:def] # => ["Simony, Friedrich"]
```

See https://pro.europeana.eu/resources/apis/record for details of the data returned in
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

### Annotations

See https://pro.europeana.eu/resources/apis/annotations for details of the responses
received from the Annotations API methods.

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

#### Create

```ruby
body = { bodyValue: 'Trombones', motivation: 'tagging', target: 'http://data.europeana.eu/item/09102/_UEDIN_214' }
annotation = Europeana::API.annotation.create(userToken: 'secret-token', body: body.to_json)
annotation[:id] # => "http://www.europeana.eu/api/annotations/myname/1234"
```

#### Update

```ruby
body = { bodyValue: 'Trombones', motivation: 'tagging' }
annotation = Europeana::API.annotation.update(provider: 'myname', id: '1234', userToken: 'secret-token', body: body.to_json)
annotation[:body][:value] # => "Trombones"
```

#### Delete

```ruby
Europeana::API.annotation.delete(provider: 'myname', id: '1234', userToken: 'secret-token') # => ""
```

## License

Licensed under the EUPL V.1.1.

For full details, see [LICENSE.md](LICENSE.md).
