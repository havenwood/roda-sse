# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'roda-sse'
  s.version = '0.2.0'
  s.license = 'MIT'
  s.summary = 'SSE integration for Roda'
  s.description = 'The roda-sse gem integrates simple SSE streaming into the roda web toolkit.'
  s.author = 'Shannon Skipper'
  s.email = 'shannonskipper@gmail.com'
  s.homepage = 'https://github.com/havenwood/roda-sse'
  s.files = %w[Gemfile LICENSE Rakefile README.md] + Dir['{spec,lib}/**/*.rb']
  s.add_dependency('roda', '~> 3.85')
  s.add_dependency('async', '~> 2.18')
  s.metadata['rubygems_mfa_required'] = 'true'
end
