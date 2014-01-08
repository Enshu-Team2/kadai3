# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "paper_house"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yasuhito Takamiya"]
  s.date = "2013-10-18"
  s.description = "Rake tasks for compiling C projects."
  s.email = ["yasuhito@gmail.com"]
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md"]
  s.homepage = "http://github.com/trema/paper-house"
  s.licenses = ["GPL3"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "Rake for C projects."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<POpen4>, ["~> 0.1.4"])
      s.add_runtime_dependency(%q<rake>, ["~> 10.1.0"])
    else
      s.add_dependency(%q<POpen4>, ["~> 0.1.4"])
      s.add_dependency(%q<rake>, ["~> 10.1.0"])
    end
  else
    s.add_dependency(%q<POpen4>, ["~> 0.1.4"])
    s.add_dependency(%q<rake>, ["~> 10.1.0"])
  end
end
