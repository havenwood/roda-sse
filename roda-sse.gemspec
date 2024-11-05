# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'roda-sse'
  s.version = '0.3.0'
  s.required_ruby_version = '>= 3.2'
  s.license = 'MIT'
  s.summary = 'SSE integration for Roda'
  s.description = 'The roda-sse gem integrates simple SSE streaming into the roda web toolkit.'
  s.authors = ['Shannon Skipper', 'Samuel Williams']
  s.email = 'shannonskipper@gmail.com'
  s.homepage = 'https://github.com/havenwood/roda-sse'
  s.files = %w[Gemfile LICENSE Rakefile README.md] + Dir['{spec,lib}/**/*.rb']
  s.add_dependency('async', '~> 2.18')
  s.add_dependency('roda', '~> 3.85')
  s.metadata['rubygems_mfa_required'] = 'true'
end
