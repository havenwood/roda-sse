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
      class Stream
        def initialize(&block)
          @block = block
          @barrier = Async::Barrier.new
        end

        def write(message)
          data = message.to_s

          @barrier.async do
            @stream.write(data)
          rescue Errno::ECONNRESET, Errno::EPIPE
            @barrier.close
          end

          data.bytesize
        end

        def <<(message)
          write(message)
          self
        end

        def call(stream)
          Sync do
            @stream = stream
            @block.call(stream)
          ensure
            close
          end
        end

        def close
          return if @closed

          @barrier.stop
          @stream&.close
          @closed = true
        end

        def closed? = @closed
      end

      module RequestMethods
        def sse(&block)
          get do
            response['content-type'] = 'text/event-stream'
            response['cache-control'] = 'no-cache'

            halt response.finish_with_body(Stream.new(&block))
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
