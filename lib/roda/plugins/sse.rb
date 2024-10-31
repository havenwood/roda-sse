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
    #       ensure
    #         stream.close
    #       end
    #     end
    #   end
    module SSE
      module RequestMethods
        def sse(&block)
          get do
            response['Content-Type'] = 'text/event-stream'
            response['Cache-Control'] = 'no-cache'

            halt response.finish_with_body(block)
          end
        end
      end
    end

    register_plugin(:sse, SSE)
  end
end
