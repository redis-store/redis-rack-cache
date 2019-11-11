# Redis stores for Rack::Cache

[![Build Status](https://travis-ci.org/redis-store/redis-rack-cache.svg?branch=master)](https://travis-ci.org/redis-store/redis-rack-cache)
[![Gem Version](https://badge.fury.io/rb/redis-rack-cache.svg)](http://badge.fury.io/rb/redis-rack-cache) [![Build Status](https://secure.travis-ci.org/redis-store/redis-rack-cache.svg?branch=master)](http://travis-ci.org/jodosha/redis-rack-cache?branch=master) [![Code Climate](https://codeclimate.com/github/jodosha/redis-store.svg)](https://codeclimate.com/github/redis-store/redis-rack-cache)

__`redis-rack-cache`__ provides a Redis backed store for __Rack::Cache__, an HTTP cache. See the main [redis-store readme](https://github.com/redis-store/redis-store) for general guidelines.

**NOTE:** This gem is necessary in addition to
[redis-rails](https://github.com/redis-store/redis-rails) if you use
Redis to store the Rails cache. `redis-rails` does not pull in this gem
by default since not all applications use `Rack::Cache` as their HTTP
cache.

## Installation

```ruby
# Gemfile
gem 'redis-rack-cache'
```

## Usage

In a Rails app, you can configure your `Rack::Cache` stores like this:

```ruby
# config/environments/production.rb
Rails.application.configure do
  config.action_dispatch.rack_cache = {
    metastore: "#{Rails.credentials.redis_url}/1/rack_cache_metastore",
    entitystore: "#{Rails.credentials.redis_url}/1/rack_cache_entitystore"
    # NOTE: `:meta_store` and `:entity_store` are also supported.
  }
end
```

For more complicated setups, like when using custom options, the
following syntax can also be used:

```ruby
# config/environments/production.rb
Rails.application.configure do
  config.action_dispatch.rack_cache = {
    meta_store: ::Rack::Cache::MetaStore::Redis.new("#{Rails.credentials.redis_url}/1/rack_cache_metastore", default_ttl: 10.days.to_i),
    entity_store: ::Rack::Cache::EntityStore::Redis.new("#{Rails.credentials.redis_url}/1/rack_cache_entitystore", default_ttl: 120.days.to_i)
    # NOTE: `:metastore` and `:entitystore` are also supported.
  }
end
```

For standalone usage (in non-Rails apps):

```ruby
# config.ru
require 'rack'
require 'rack/cache'
require 'redis-rack-cache'

use Rack::Cache,
  metastore: 'redis://localhost:6379/0/metastore',
  entitystore: 'redis://localhost:6380/0/entitystore'
```

### Compression

`Redis::Rack::Cache` supports data compression for entities over 1K when
transmitting back and forth over the wire to your Redis server.
Compressing data can improve bandwidth usage as well as RAM/storage
consumption, and is recommended if you operate a large-scale Rails
application.

To enable this feature, pass the `:compress` option when configuring
`Rack::Cache`:

```ruby
Rails.application.configure do
  config.action_dispatch.rack_cache = {
    metastore: "#{Rails.credentials.redis_url}/1",
    entitystore: "#{Rails.credentials.redis_url}/2",
    compress: true
  }
end
```

If compression is turned on, but no driver has been selected,
`Redis::Rack::Cache` will use Ruby's internal **ZLib** integrations and
compress entities with GZip. You can specify `:deflate` if you want to
use the deflate algorithm, `:gzip` if you want to be specific about it,
or a custom object that responds to `.deflate(data)` and
`.inflate(data)` to compress/decompress data, respectively. For example,
you can use Google's [Snappy](http://google.github.io/snappy/) for
[ludicrous-speed](https://www.youtube.com/watch?v=ygE01sOhzz0)
compression and decompression like this:

```ruby
Rails.application.configure do
  config.action_dispatch.rack_cache = {
    metastore: "#{Rails.credentials.redis_url}/1",
    entitystore: "#{Rails.credentials.redis_url}/2",
    compress: Snappy
  }
end
```

**NOTE:** Since metadata would have to be marshalled before compression
in order to rehydrate it back into an object, only data stored in the
EntityStore is compressed for now. We'd love your feedback though,
let us know if there's a good use case for MetaStore compression!

## Development

First, get the project set up on your local machine:

```bash
git clone https://github.com/redis-store/redis-rack-cache.git
cd redis-rack-cache
bundle install
```

You can run the following command to run the test suite:

```bash
bundle exec rake test
```

If you are on **Snow Leopard** you have to run `env ARCHFLAGS="-arch x86_64" bundle exec rake`

## Copyright

2009 - 2013 Luca Guidi - [http://lucaguidi.com](http://lucaguidi.com), released under the MIT license
