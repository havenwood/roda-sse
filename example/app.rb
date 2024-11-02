# frozen_string_literal: true

require 'roda'

class App < Roda
  WIDTH = 40
  HEIGHT = 25
  PIXELS = WIDTH * HEIGHT
  PER_SECOND = 2_000
  DELAY = 1.fdiv(PER_SECOND)

  plugin :direct_call
  plugin :head
  plugin :plain_hash_response_headers
  plugin :render
  plugin :sse

  route do |r|
    r.root do
      view 'index'
    end

    r.is 'streaming' do
      r.sse do |stream|
        # bomb = 10
        loop do
          # bomb -= 1
          # if bomb.zero?
          #   raise '💣'
          # end

          stream << message
          sleep DELAY
        end
      end
    end
  end

  private

  def message
    pixel = random_pixel
    html = <<~HTML
      <div class="grid-item" \
        sse-swap="#{pixel}" \
        style="background: #{random_color}">\
      </div>
    HTML

    "event: #{pixel}\ndata: #{html}\n\n"
  end

  def random_pixel = rand PIXELS
  def random_color = format '#%06x', rand(0x1000000)
end
