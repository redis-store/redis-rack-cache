require 'digest/sha1'
require 'rack/cache/key'
require 'rack/cache/meta_store'
require 'redis-rack-cache/constants'
require 'rack/cache/redis_base'

module Rack
  module Cache
    class MetaStore
      class Redis < self
        include RedisBase

        def read(key)
          cache.get(hexdigest(key)) || []
        end

        def write(key, entries, ttl=0)
          ttl = ttl.to_i.zero? ? default_ttl : ttl
          cache.setex(hexdigest(key), ttl, entries)
        end

        def purge(key)
          cache.del(hexdigest(key))
          nil
        end
      end

      REDIS = REDISS = Redis
    end
  end
end
