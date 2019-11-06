require 'rack/cache/entity_store'
require 'redis-rack-cache/constants'
require 'rack/cache/redis_base'
require 'zlib'
require 'zlib/gzip_compression'

module Rack
  module Cache
    class EntityStore
      class Redis < self
        MINIMUM_COMPRESSION_BYTESIZE = 1_000

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
          return data unless compress? data

          deflater.deflate(data)
        end

        def decompress(data)
          return data unless compress?

          inflater.inflate(data) rescue data
        end

        private

        def deflater
          case options[:compress]
          when :deflate
            Zlib::Deflate
          when :gzip, true
            Zlib::GzipCompression
          when false
            nil
          else
            options[:compress]
          end
        end

        def inflater
          case options[:compress]
          when :deflate
            Zlib::Inflate
          when :gzip, true
            Zlib::GzipCompression
          when false
            nil
          else
            options[:compress]
          end
        end

        def compress?(data = nil)
          return options[:compress] if data.nil?

          options[:compress] && data.bytesize >= MINIMUM_COMPRESSION_BYTESIZE
        end
      end

      REDIS = REDISS = Redis
    end
  end
end
