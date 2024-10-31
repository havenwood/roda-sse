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
        stream.write "data: hola\n\n"
      ensure
        stream.close
      end
    end
  end
end

def app = App.freeze.app

describe 'roda-sse plugin' do
  include Rack::Test::Methods

  prove_it!

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
    assert_instance_of Proc, response_body

    response_body.call(stream)

    stream.verify
  end
end
