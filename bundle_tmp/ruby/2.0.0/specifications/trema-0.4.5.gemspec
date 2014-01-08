# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "trema"
  s.version = "0.4.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yasuhito Takamiya"]
  s.date = "2013-11-08"
  s.description = "Trema is a full-stack, easy-to-use framework for developing OpenFlow controllers in Ruby and C."
  s.email = ["yasuhito@gmail.com"]
  s.executables = ["trema", "trema-config"]
  s.extensions = ["Rakefile"]
  s.extra_rdoc_files = ["README.md"]
  s.files = ["bin/trema", "bin/trema-config", "README.md", "Rakefile"]
  s.homepage = "http://github.com/trema/trema"
  s.licenses = ["GPL2"]
  s.require_paths = ["ruby"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "2.0.14"
  s.summary = "Full-stack OpenFlow framework."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bundler>, [">= 0"])
      s.add_runtime_dependency(%q<gli>, ["~> 2.8.1"])
      s.add_runtime_dependency(%q<paper_house>, ["~> 0.5.0"])
      s.add_runtime_dependency(%q<pio>, ["~> 0.2.6"])
      s.add_runtime_dependency(%q<rake>, ["~> 10.1.0"])
      s.add_runtime_dependency(%q<rdoc>, ["~> 4.0.1"])
    else
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<gli>, ["~> 2.8.1"])
      s.add_dependency(%q<paper_house>, ["~> 0.5.0"])
      s.add_dependency(%q<pio>, ["~> 0.2.6"])
      s.add_dependency(%q<rake>, ["~> 10.1.0"])
      s.add_dependency(%q<rdoc>, ["~> 4.0.1"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<gli>, ["~> 2.8.1"])
    s.add_dependency(%q<paper_house>, ["~> 0.5.0"])
    s.add_dependency(%q<pio>, ["~> 0.2.6"])
    s.add_dependency(%q<rake>, ["~> 10.1.0"])
    s.add_dependency(%q<rdoc>, ["~> 4.0.1"])
  end
end
