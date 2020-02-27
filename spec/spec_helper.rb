RSpec.configure do |c|
  c.mock_with :rspec
end

require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet'
require 'rspec-puppet-facts'

include RspecPuppetFacts

require 'simplecov'
require 'simplecov-console'

SimpleCov.start do
  add_filter '/spec'
  add_filter '/vendor'
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ])
end

fixture_path = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures')
RSpec.configure do |c|
  c.module_path     = File.join(fixture_path, 'modules')
  c.manifest_dir    = File.join(fixture_path, 'manifests')
  c.manifest        = File.join(fixture_path, 'manifests', 'site.pp')
  c.environmentpath = File.join(Dir.pwd, 'spec')
  c.hiera_config    = File.join(fixture_path, 'hiera.yaml')
  c.default_facter_version = '3.14.0'
end
at_exit { RSpec::Puppet::Coverage.report! }
