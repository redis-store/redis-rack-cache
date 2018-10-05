require 'rack/cache/entity_store'
require 'redis-rack-cache/constants'
require 'rack/cache/redis_base'

module Rack
  module Cache
    class EntityStore
      class Redis < self
        include RedisBase

        def exist?(key)
          cache.exists key
        end

        def read(key)
          cache.get key
        end

        def write(body, ttl=0)
          buf = StringIO.new
          key, size = slurp(body) {|part| buf.write(part) }
          ttl = ttl.to_i.zero? ? default_ttl : ttl

          return unless cache.setex(key, ttl, buf.string)
          [key, size]
        end

        def purge(key)
          cache.del key
          nil
        end
      end

      REDIS = REDISS = Redis
    end
  end
end
