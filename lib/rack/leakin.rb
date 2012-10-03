require 'process_memory'
require 'rack/leakin/version'
require 'rack'

module Rack
  class Leakin
    class << self
      attr_writer :threshold, :handler, :logger

      def threshold
        @threshold ||= 131072 # 128 Mb by default
      end

      def handler
        @handler ||= lambda do |env, beginning, ending|
          logger.warn "*** [Memory leak detected] #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}, #{beginning}KB --> #{ending}KB"
        end
      end

      def logger
        @logger ||= begin
          if defined?(Rails)
            ::Rails.logger
          else
            ::Logger.new('rack-leaker.log')
          end
        end
      end
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      beginning = Process.memory

      @app.call(env).tap do
        ending = Process.memory

        if ending - beginning > self.class.threshold
          self.class.handler.call(env, beginning, ending)
        end
      end
    end
  end
end
