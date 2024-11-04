# frozen_string_literal: true

require 'async'

class Roda
  module RodaPlugins
    # Example:
    #
    #   plugin :sse
    #
    #   route do |r|
    #     r.root do
    #       # GET /
    #       r.sse do |stream|
    #         stream.write "data: hola\n\n"
    #       end
    #     end
    #   end
    module SSE
      class Output
        def initialize(stream)
          @stream = stream
        end

        def write(message)
          data = message.to_s
          @stream.write(data)
          return data.bytesize
        end

        def <<(message)
          @stream.write(message.to_s)
          return self
        end

        def close(error = nil)
          return unless @stream

          stream = @stream
          @stream = nil
          stream.close_write(error)
        end
      end

      Body = Data.define(:block) do
        def call(stream)
          output = Output.new(stream)
          block.call(output)
        rescue => error
          output.close(error)
        ensure
          output.close
        end
      end

      module RequestMethods
        HEADERS = {
          'content-type' => 'text/event-stream',
          'cache-control' => 'no-cache',
        }.freeze

        def sse(&block)
          get do
            halt [200, HEADERS.dup, Body.new(block)]
          end
        end
      end

      module InstanceMethods
        def last_event_id
          env['HTTP_LAST_EVENT_ID']
        end
      end
    end

    register_plugin(:sse, SSE)
  end
end
