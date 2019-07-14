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

## Development

First, get the project set up on your local machine:

```bash
git clone https://github.com/redis-store/redis-rack-cache.git
cd redis-rack-cache
bundle install
```

You can run the following command to execute the test suite:

```bash
bundle exec rake test
```

If you are on **Snow Leopard** you have to run `env ARCHFLAGS="-arch x86_64" bundle exec rake`

## Copyright

2009 - 2013 Luca Guidi - [http://lucaguidi.com](http://lucaguidi.com), released under the MIT license
