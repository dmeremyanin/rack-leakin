require 'rack/leaking/version'
require 'rack'

module Rack
  class Leakin
    attr_writer :threshold, :handler, :logger

    def initialize(app)
      @app = app
    end

    def threshold
      @threshold ||= begin
        options[:threshold] || 131072 # 128 Mb by default
      end
    end

    def handler
      @handler ||= lambda do |env, beginning, ending|
        logger.warn "*** [Memory leak detected] #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}, #{beginning}KB --> #{ending}KB"
      end
    end

    def call(env)
      beginning = Process.memory

      @app.call(env).tap do
        ending = Process.memory

        if ending - beginning > threshold
          handler.call(env, beginning, ending)
        end
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
end
