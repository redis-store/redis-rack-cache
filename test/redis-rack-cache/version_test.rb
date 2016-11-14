require 'test_helper'

describe Redis::Rack::Cache::VERSION do
  it 'returns current version' do
    assert !Redis::Rack::Cache::VERSION.nil?
  end
end
