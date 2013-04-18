# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "authorized_keys"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bo Jeanes"]
  s.date = "2013-04-17"
  s.description = "Library to manage authorized_keys files"
  s.email = "me@bjeanes.com"
  s.files = ["LICENSE.txt", "README.rdoc", "lib/authorized_keys", "lib/authorized_keys/file.rb", "lib/authorized_keys/key.rb", "lib/authorized_keys/version.rb", "lib/authorized_keys.rb", "spec/authorized_keys", "spec/authorized_keys/file_spec.rb", "spec/authorized_keys/key_spec.rb", "spec/fixtures", "spec/fixtures/keys", "spec/fixtures/keys/1.pub", "spec/fixtures/keys/2.pub", "spec/fixtures/keys/3.pub", "spec/fixtures/keys/4.pub", "spec/spec_helper.rb", "spec/support", "spec/support/fixtures.rb"]
  s.homepage = "https://github.com/bjeanes/authorized_keys"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.0"
  s.summary = "Library to manage authorized_keys files"
  s.test_files = ["spec/authorized_keys", "spec/authorized_keys/file_spec.rb", "spec/authorized_keys/key_spec.rb", "spec/fixtures", "spec/fixtures/keys", "spec/fixtures/keys/1.pub", "spec/fixtures/keys/2.pub", "spec/fixtures/keys/3.pub", "spec/fixtures/keys/4.pub", "spec/spec_helper.rb", "spec/support", "spec/support/fixtures.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.4.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.2.2"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.4.0"])
      s.add_dependency(%q<rake>, ["~> 0.9.2.2"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.4.0"])
    s.add_dependency(%q<rake>, ["~> 0.9.2.2"])
  end
end
