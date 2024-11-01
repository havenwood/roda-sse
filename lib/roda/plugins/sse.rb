# frozen_string_literal: true

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
        end

        def write(message)
          data = message.to_s
          @stream.write(data)
          data.bytesize
        end

        def <<(message)
          @stream.write(message.to_s)
          self
        end

        def call(stream)
          @stream = stream
          @block.call(stream)
        ensure
          close
        end

        def close
          @stream&.close
          @closed = true
        end

        def closed? = @closed
      end

      module RequestMethods
        def sse(&block)
          get do
            response['Content-Type'] = 'text/event-stream'
            response['Cache-Control'] = 'no-cache'

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
