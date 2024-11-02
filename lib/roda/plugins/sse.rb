# frozen_string_literal: true

require 'async'
require 'async/barrier'

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
          write(message)
          self
        end

        def close(error = nil)
          if stream = @stream
            @stream = nil
            stream.close_write(error)
          end
        end
      end

      class Body
        def initialize(block)
          @block = block
        end
        
        def call(stream)
          output = Output.new(stream)
          @block.call(output)
        rescue => error
        ensure
          stream.close_write(error)
        end
      end

      module RequestMethods
        HEADERS = {
          'content-type' => 'text/event-stream',
          'cache-control' => 'no-cache',
        }.freeze

        def sse(&block)
          get do
            response['content-type'] = 'text/event-stream'
            response['cache-control'] = 'no-cache'

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
