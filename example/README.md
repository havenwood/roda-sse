# Example roda-sse streaming app

This example starts with 1,000 colorless <div> tags on an empty page.
A single HTTP connection then streams server-sent events to change the
background color of a random <div> several thousand times per second
using [Async](https://github.com/socketry/async) Tasks.

## Installation

```sh
bundle
```

## Deployment

In development:
```sh
bundle exec falcon serve
```

Or in production edit `falcon.rb` and:
```sh
bundle exec falcon host
```

## Usage

Navigate your browser to the Falcon endpoint base url.
