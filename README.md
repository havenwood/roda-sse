# roda-sse

The roda-sse Roda plugin adds SSE provides a streaming interface for
server-sent events. Each stream is wrapped in an [Async](https://github.com/socketry/async) reactor
and events are sent asyncronously via tasks. The roda-sse plugin sets
appropriate SSE headers, handles disconnection errors, ensures
streams are properly closed and provies a `last_event_id` helper.

## Installation

```sh
gem install roda-sse
```

## Source Code

Source code is available on GitHub at
https://github.com/havenwood/roda-sse

## Usage

See the [examples/](https://github.com/havenwood/roda-sse/tree/main/example) directory for an example app.

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
end
```
