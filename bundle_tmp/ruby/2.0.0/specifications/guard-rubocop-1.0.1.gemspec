# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "guard-rubocop"
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yuji Nakayama"]
  s.date = "2013-12-02"
  s.description = "Guard::Rubocop automatically checks Ruby code style with RuboCop when files are modified."
  s.email = ["nkymyj@gmail.com"]
  s.homepage = "https://github.com/yujinakayama/guard-rubocop"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "Guard plugin for RuboCop"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<guard>, ["~> 2.0"])
      s.add_runtime_dependency(%q<rubocop>, ["~> 0.10"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 4.0"])
      s.add_development_dependency(%q<ruby_gntp>, ["~> 0.3"])
    else
      s.add_dependency(%q<guard>, ["~> 2.0"])
      s.add_dependency(%q<rubocop>, ["~> 0.10"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rspec>, ["~> 2.14"])
      s.add_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_dependency(%q<guard-rspec>, ["~> 4.0"])
      s.add_dependency(%q<ruby_gntp>, ["~> 0.3"])
    end
  else
    s.add_dependency(%q<guard>, ["~> 2.0"])
    s.add_dependency(%q<rubocop>, ["~> 0.10"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rspec>, ["~> 2.14"])
    s.add_dependency(%q<simplecov>, ["~> 0.7"])
    s.add_dependency(%q<guard-rspec>, ["~> 4.0"])
    s.add_dependency(%q<ruby_gntp>, ["~> 0.3"])
  end
end
