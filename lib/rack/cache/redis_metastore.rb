require 'digest/sha1'
require 'rack/cache/key'
require 'rack/cache/meta_store'
require 'redis-rack-cache/constants'
require 'rack/cache/redis_base'

module Rack
  module Cache
    class MetaStore
      class Redis < self
        # The Redis instance used to communicated with the Redis daemon.
        attr_reader :cache

        def initialize(server, options = {})
          @cache = ::Redis::Store::Factory.create(server)
          self.default_ttl = options[:default_ttl] || ::Redis::Rack::Cache::DEFAULT_TTL
        end

        def read(key)
          cache.get(hexdigest(key)) || []
        end

        def write(key, entries, ttl=0)
          ttl = self.default_ttl if ttl.zero?
          cache.setex(hexdigest(key), ttl, entries)
        end

        def purge(key)
          cache.del(hexdigest(key))
          nil
        end
      end

      REDIS = Redis
    end
  end
end
