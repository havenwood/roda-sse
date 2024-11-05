# Example roda-sse streaming app

This example starts with 1,000 colorless <div> tags on an empty page.
The open HTTP connection then streams server-sent events using [Async](https://github.com/socketry/async)
on the server and [HTMX](https://github.com/bigskysoftware/htmx) on the client to randomly swap <div> tags with
replacement <div> tags that have a randomly selected background color.

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

Navigate your browser to the Falcon endpoint at: https://localhost:9292
