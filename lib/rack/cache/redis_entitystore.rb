require 'rack/cache/entity_store'
require 'redis-rack-cache/constants'
require 'rack/cache/redis_base'

module Rack
  module Cache
    class EntityStore
      class Redis < self
        include RedisBase

        attr_reader :default_ttl

        def initialize(server, options = {})
          @cache = ::Redis::Store::Factory.create(server)
          @options = options
          @options[:default_ttl] ||= ::Redis::Rack::Cache::DEFAULT_TTL
        end

        def exist?(key)
          cache.exists key
        end

        def read(key)
          cache.get key
        end

        def write(body, ttl=0)
          buf = StringIO.new
          key, size = slurp(body) {|part| buf.write(part) }
          ttl = @options[:default_ttl] if ttl.zero?

          [key, size] if cache.setex(key, ttl, buf.string)
        end

        def purge(key)
          cache.del key
          nil
        end
      end

      REDIS = Redis
    end
  end
end
