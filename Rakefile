# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)

task :gemspec do
  require 'rubygems/specification'
  require 'authorized_keys/version'
  require 'date'

  spec = Gem::Specification.new do |gem|
    gem.specification_version = 3 if gem.respond_to?(:specification_version=)
    gem.required_rubygems_version = Gem::Requirement.new(">= 0") if gem.respond_to?(:required_rubygems_version=)

    gem.name        = "authorized_keys"
    gem.version     = AuthorizedKeys::VERSION
    gem.summary     = %Q{Library to manage authorized_keys files}
    gem.description = gem.summary
    gem.homepage    = "https://github.com/bjeanes/authorized_keys"
    gem.license     = "MIT"

    gem.author = "Bo Jeanes"
    gem.email  = "me@bjeanes.com"

    gem.date = Date.today.strftime

    gem.files          = %w(LICENSE.txt README.rdoc) + Dir.glob("{lib,spec}/**/*")
    gem.require_paths  = %w[lib]
    gem.test_files     = gem.files.select { |path| path =~ /^spec\// }
    gem.has_rdoc       = false

    gem.add_development_dependency "rspec", "~> 2.4.0"
    gem.add_development_dependency "rake", "~> 0.9.2.2"
  end

  File.open("#{spec.name}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

task :gem => :gemspec do
  puts "Building gem to pkg/\n\n"

  if system("gem build authorized_keys.gemspec")
    FileUtils.mkdir_p("pkg")
    FileUtils.mv("authorized_keys-#{AuthorizedKeys::VERSION}.gem", "pkg")
  else
    abort "Building gem failed!"
  end
end

begin
  require 'rspec/core'
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = FileList['spec/**/*_spec.rb']
  end
rescue LoadError
  task :spec do
    abort("RSpec not installed. Please run `bundle install`")
  end
end

task :default => :spec
