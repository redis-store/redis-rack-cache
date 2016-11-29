require 'digest/sha1'
require 'rack/utils'
require 'rack/cache/key'
require 'rack/cache/meta_store'

module Rack
  module Cache
    class MetaStore
      class RedisBase < self
        extend Rack::Utils

        # The Redis::Store object used to communicate with the Redis daemon.
        attr_reader :cache

        class << self
          attr_accessor :default_ttl
        end

        def self.resolve(uri, options = {})
          new ::Redis::Store::Factory.resolve(uri.to_s), options
        end
      end

      class Redis < RedisBase
        # The Redis instance used to communicated with the Redis daemon.
        attr_reader :cache

        def initialize(server, options = {})
          @cache = ::Redis::Store::Factory.create(server)
          self.class.default_ttl = options[:default_ttl] || 86_400 * 365 # 1 year
        end

        def read(key)
          cache.get(hexdigest(key)) || []
        end

        def write(key, entries, ttl=0)
          ttl = self.class.default_ttl if ttl.zero?
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
