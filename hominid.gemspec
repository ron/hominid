# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hominid}
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Getting"]
  s.date = %q{2009-03-25}
  s.description = %q{Hominid is a Rails GemPlugin for interacting with the Mailchimp API.}
  s.email = %q{brian@terra-firma-design.com}
  s.files = [
    "hominid.yml.tpl",
    "lib/hominid.rb",
    "MIT-LICENSE",
    "README.textile",
    "test/hominid_test.rb",
    "test/test_helper.rb"
    ]
  s.has_rdoc = true
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.homepage = %q{http://github.com/bgetting/hominid}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{hominid}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Hominid is a Rails GemPlugin for interacting with the Mailchimp API.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
    
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mime-types>, [">= 1.15"])
      s.add_runtime_dependency(%q<diff-lcs>, [">= 1.1.2"])
    else
      s.add_dependency(%q<mime-types>, [">= 1.15"])
      s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
    end
  else
    s.add_dependency(%q<mime-types>, [">= 1.15"])
    s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
  end
end