# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/clean'
require 'rake/testtask'

CLEAN.include %w[pkg/roda-sse-*.gem].freeze

task default: :test

Rake::TestTask.new do |test|
  test.pattern = 'spec/**/*_spec.rb'
  test.warning = false
end
