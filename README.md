# Redis stores for Rack::Cache

[![Build Status](https://travis-ci.org/redis-store/redis-rack-cache.svg?branch=master)](https://travis-ci.org/redis-store/redis-rack-cache)
[![Gem Version](https://badge.fury.io/rb/redis-rack-cache.png)](http://badge.fury.io/rb/redis-rack-cache) [![Build Status](https://secure.travis-ci.org/redis-store/redis-rack-cache.png?branch=master)](http://travis-ci.org/jodosha/redis-rack-cache?branch=master) [![Code Climate](https://codeclimate.com/github/jodosha/redis-store.png)](https://codeclimate.com/github/redis-store/redis-rack-cache)

__`redis-rack-cache`__ provides a Redis backed store for __Rack::Cache__, an HTTP cache. See the main [redis-store readme](https://github.com/redis-store/redis-store) for general guidelines.

## Installation

```ruby
# Gemfile
gem 'redis-rack-cache'
```

## Usage

If you are using redis-store with Rails, consider using the [redis-rails gem](https://github.com/redis-store/redis-rails) instead.
However, configuration can be done a such:

```ruby
# config/application.rb
module MyApplication
  class Application < Rails::Application
    config.action_dispatch.rack_cache = {
      metastore: ::Rack::Cache::EntityStore::Redis.new('redis://localhost:6379/0/metastore', default_ttl: 10.days.to_i),
      entity_store: ::Rack::Cache::MetaStore::Redis.new('redis://localhost:6380/0/entitystore', default_ttl: 120.days.to_i)
    }
  end
end
```

For standalone usage:

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
