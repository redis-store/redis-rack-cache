require 'rack/cache/entity_store'
require 'redis-rack-cache/constants'
require 'rack/cache/redis_base'
require 'zlib'
require 'zlib/gzip_compression'

module Rack
  module Cache
    class EntityStore
      class Redis < self
        include RedisBase

        def exist?(key)
          cache.exists key
        end

        def read(key)
          raw = cache.get(key)

          return if raw.nil?

          decompress(raw).force_encoding('utf-8')
        end

        def write(body, ttl=0)
          buf = StringIO.new
          key, size = slurp(body) {|part| buf.write(part) }
          ttl = ttl.to_i.zero? ? default_ttl : ttl
          value = compress(buf.string)

          return unless cache.setex(key, ttl, value)

          [key, size]
        end

        def purge(key)
          cache.del key
          nil
        end

        protected

        def compress(data)
          return data unless ::Redis::Rack::Cache.compress? data

          deflater.deflate(data)
        end

        def decompress(data)
          return data unless ::Redis::Rack::Cache.compress?

          inflater.inflate(data) rescue data
        end

        private

        def deflater
          case ::Redis::Rack::Cache.compression
          when :deflate
            Zlib::Deflate
          when :gzip, true
            Zlib::GzipCompression
          when false
            nil
          else
            ::Redis::Rack::Cache.compression
          end
        end

        def inflater
          case ::Redis::Rack::Cache.compression
          when :deflate
            Zlib::Inflate
          when :gzip, true
            Zlib::GzipCompression
          when false
            nil
          else
            ::Redis::Rack::Cache.compression
          end
        end
      end

      REDIS = REDISS = Redis
    end
  end
end
