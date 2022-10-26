require 'segment_io/analytics/version'
require 'segment_io/analytics/defaults'
require 'segment_io/analytics/utils'
require 'segment_io/analytics/field_parser'
require 'segment_io/analytics/client'
require 'segment_io/analytics/worker'
require 'segment_io/analytics/transport'
require 'segment_io/analytics/response'
require 'segment_io/analytics/logging'
require 'segment_io/analytics/test_queue'

module SegmentIO
  class Analytics
    # Initializes a new instance of {Segment::Analytics::Client}, to which all
    # method calls are proxied.
    #
    # @param options includes options that are passed down to
    #   {Segment::Analytics::Client#initialize}
    # @option options [Boolean] :stub (false) If true, requests don't hit the
    #   server and are stubbed to be successful.
    def initialize(options = {})
      Transport.stub = options[:stub] if options.has_key?(:stub)
      @client = SegmentIO::Analytics::Client.new options
    end

    def method_missing(message, *args, &block)
      if @client.respond_to? message
        @client.send message, *args, &block
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @client.respond_to?(method_name) || super
    end

    include Logging
  end
end
