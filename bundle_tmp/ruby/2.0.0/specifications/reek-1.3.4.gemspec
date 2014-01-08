# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "reek"
  s.version = "1.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kevin Rutherford", "Timo Roessner", "Matijs van Zuijlen"]
  s.date = "2013-10-14"
  s.description = "Reek is a tool that examines Ruby classes, modules and methods\nand reports any code smells it finds.\n"
  s.email = ["timo.roessner@googlemail.com"]
  s.executables = ["reek"]
  s.extra_rdoc_files = ["CHANGELOG", "License.txt"]
  s.files = ["bin/reek", "CHANGELOG", "License.txt"]
  s.homepage = "http://wiki.github.com/troessner/reek"
  s.post_install_message = "Thank you for downloading Reek. For info see the reek wiki http://wiki.github.com/troessner/reek"
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "reek"
  s.rubygems_version = "2.0.14"
  s.summary = "Code smell detector for Ruby"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby_parser>, ["~> 3.2"])
      s.add_runtime_dependency(%q<sexp_processor>, [">= 0"])
      s.add_runtime_dependency(%q<ruby2ruby>, ["~> 2.0.2"])
      s.add_development_dependency(%q<bundler>, ["~> 1.1"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.12"])
      s.add_development_dependency(%q<flay>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<ruby_parser>, ["~> 3.2"])
      s.add_dependency(%q<sexp_processor>, [">= 0"])
      s.add_dependency(%q<ruby2ruby>, ["~> 2.0.2"])
      s.add_dependency(%q<bundler>, ["~> 1.1"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.12"])
      s.add_dependency(%q<flay>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<ruby_parser>, ["~> 3.2"])
    s.add_dependency(%q<sexp_processor>, [">= 0"])
    s.add_dependency(%q<ruby2ruby>, ["~> 2.0.2"])
    s.add_dependency(%q<bundler>, ["~> 1.1"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.12"])
    s.add_dependency(%q<flay>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
