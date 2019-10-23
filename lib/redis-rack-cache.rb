require 'redis-store'
require 'rack/cache'
require 'rack/cache/redis_entitystore'
require 'rack/cache/redis_metastore'
require 'redis-rack-cache/version'

class Redis
  module Rack
    module Cache
      MINIMUM_COMPRESSION_BYTESIZE = 1_000

      def self.compression
        return @compression if defined? @compression
        false
      end

      def self.compression=(value)
        @compression = value
      end

      def self.compress?(data = nil)
        return compression if data.nil?

        compression && data.bytesize >= MINIMUM_COMPRESSION_BYTESIZE
      end
    end
  end
end
