require 'rack/utils'

module Rack
  module Cache
    module RedisBase
      def self.included(base)
        base.instance_eval do
          extend Rack::Utils

          attr_reader :cache
          attr_accessor :default_ttl
        end
      end

      def self.resolve(uri)
        new ::Redis::Store::Factory.resolve(uri.to_s)
      end

      def open(key)
        data = read(key)
        data && [data]
      end
    end
  end
end
