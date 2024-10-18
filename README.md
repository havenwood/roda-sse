# roda-sse

The roda-sse Roda plugin adds SSE headers and provides Rack 3 streaming for you to send your own events.

## Installation

```sh
gem install roda-sse
```

## Source Code

Source code is available on GitHub at
https://github.com/havenwood/roda-sse

## Usage

roda-sse is a Roda plugin, so you need to load it into your Roda
application similar to other plugins:

```ruby
class App < Roda
  plugin :sse
end
```

In your routing block, you can then use `r.sse` to stream with the correct headers.

```ruby
r.sse do |stream|
  stream << "data: hello\n\n"
  stream << "data: world\n\n"
ensure
  stream.close
end
```
