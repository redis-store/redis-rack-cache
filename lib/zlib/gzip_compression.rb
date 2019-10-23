module Zlib
  # Compress data over the wire to Redis with GZip. This code was mostly
  # stolen from `Dalli::GzipCompressor`.
  #
  # https://github.com/petergoldstein/dalli/blob/master/lib/dalli/compressor.rb
  module GzipCompression
    # Compress the given data with GZip.
    #
    # @param [String] data - Uncompressed data.
    # @return [String]
    def self.deflate(data)
      io = StringIO.new(String.new(""), "w")
      gz = Zlib::GzipWriter.new(io)

      gz.write(data)
      gz.close

      io.string
    end

    # Decompress the given data with GZip.
    #
    # @param [String] data - Compressed data.
    # @return [String] Decompressed data.
    def self.inflate(data)
      io = StringIO.new(data, "rb")
      gz = Zlib::GzipReader.new(io)

      gz.read
    end
  end
end
