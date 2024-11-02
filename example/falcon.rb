#!/usr/bin/env falcon host
# frozen_string_literal: true

load :rack, :supervisor

service 'havenwood.dev' do
  include Falcon::Environment::Rack

  endpoint do
    Async::HTTP::Endpoint
      .parse('http2://127.0.0.1:9292')
    # .with(protocol: Async::HTTP::Protocol::HTTP2)
  end
end

service 'supervisor' do
  include Falcon::Environment::Supervisor
end
