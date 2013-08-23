# Redis stores for Rack::Cache

__`redis-rack-cache`__ provides a Redis backed store for __Rack::Cache__, an HTTP cache. See the main [redis-store readme](https://github.com/jodosha/redis-store) for general guidelines.

## Installation

```ruby
# Gemfile
gem 'redis-rack-cache'
```

### Usage

If you are using redis-store with Rails, consider using the [redis-rails gem](https://github.com/jodosha/redis-store/tree/master/redis-rails) instead. For standalone usage:

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
git clone git://github.com/jodosha/redis-rack-cache.git
cd redis-rack-cache
bundle install
bundle exec rake
```

If you are on **Snow Leopard** you have to run `env ARCHFLAGS="-arch x86_64" bundle exec rake`

## Copyright

(c) 2009 - 2013 Luca Guidi - [http://lucaguidi.com](http://lucaguidi.com), released under the MIT license
