#!/usr/bin/env falcon host
# frozen_string_literal: true

require 'falcon/environment/rack'
require 'falcon/environment/tls'
require 'falcon/environment/self_signed_tls'

service 'havenwood.dev' do
  include Falcon::Environment::Rack
  include Falcon::Environment::TLS
  include Falcon::Environment::SelfSignedTLS

  endpoint do
    Async::HTTP::Endpoint.for(scheme, "localhost", port: 9292, protocol: protocol, ssl_context: ssl_context)
  end
end
