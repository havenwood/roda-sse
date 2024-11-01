# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/proveit'
require 'rack/test'
require 'roda'

class App < Roda
  plugin :sse

  route do |r|
    r.root do
      r.sse do |stream|
        last_event_id
        stream.write "data: hola\n\n"
      end
    end
  end
end

def app = App.freeze.app

describe 'roda-sse plugin' do
  prove_it!

  describe 'roda app' do
    include Rack::Test::Methods

    it 'responds 200 OK' do
      get '/'

      assert last_response.ok?
    end

    it 'does not respond to PUT' do
      post '/'

      refute last_response.ok?
    end

    it 'has SSE headers' do
      get '/'

      headers = {'content-type' => 'text/event-stream', 'cache-control' => 'no-cache'}
      assert_equal headers, last_response.headers
    end

    it 'streams the body' do
      get '/'

      stream = Minitest::Mock.new
      stream.expect(:write, nil, ["data: hola\n\n"])
      stream.expect(:close, nil)
      response_body = last_response.instance_variable_get(:@body)
      assert_instance_of Roda::RodaPlugins::SSE::Stream, response_body

      response_body.call(stream)

      stream.verify
    end
  end

  describe 'stream class' do
    before do
      @stream = Roda::RodaPlugins::SSE::Stream.new do |stream|
        stream << 42
        stream.write(43)
      end
    end

    it 'opens' do
      refute @stream.closed?
    end

    it 'streams and closes' do
      stream = Minitest::Mock.new
      stream.expect(:<<, nil, [42])
      stream.expect(:write, nil, [43])
      stream.expect(:close, nil)
      @stream.call(stream)
      assert_instance_of Roda::RodaPlugins::SSE::Stream, @stream

      stream.verify
    end
  end
end
