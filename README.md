# Redis stores for Rack::Cache

## New maintainer required

**I am currently looking for a new maintainer for this gem. I am no longer doing any more work on this myself. Please contact me@ryanbigg.com if you'd like to take over this project.**

__`redis-rack-cache`__ provides a Redis backed store for __Rack::Cache__, an HTTP cache. See the main [redis-store readme](https://github.com/redis-store/redis-store) for general guidelines.

## Installation

```ruby
# Gemfile
gem 'redis-rack-cache'
```

## Usage

If you are using redis-store with Rails, consider using the [redis-rails gem](https://github.com/redis-store/redis-rails) instead. For standalone usage:

```ruby
# config.ru
require 'rack'
require 'rack/cache'
require 'redis-rack-cache'

use Rack::Cache,
  metastore: 'redis://localhost:6379/0/metastore',
  entitystore: 'redis://localhost:6380/0/entitystore'
```

## Running tests

```shell
gem install bundler
git clone git://github.com/redis-store/redis-rack-cache.git
cd redis-rack-cache
bundle install
bundle exec rake
```

If you are on **Snow Leopard** you have to run `env ARCHFLAGS="-arch x86_64" bundle exec rake`

## Status

[![Gem Version](https://badge.fury.io/rb/redis-rack-cache.png)](http://badge.fury.io/rb/redis-rack-cache) [![Build Status](https://secure.travis-ci.org/redis-store/redis-rack-cache.png?branch=master)](http://travis-ci.org/jodosha/redis-rack-cache?branch=master) [![Code Climate](https://codeclimate.com/github/jodosha/redis-store.png)](https://codeclimate.com/github/redis-store/redis-rack-cache)

## Copyright

2009 - 2013 Luca Guidi - [http://lucaguidi.com](http://lucaguidi.com), released under the MIT license
