# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "realex"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Campbell"]
  s.date = "2013-05-30"
  s.description = "A Ruby library to make use of the payments API at http://realexpayments.com"
  s.email = "paul@rslw.com"
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "README.md",
    "Rakefile",
    "lib/real_ex/address.rb",
    "lib/real_ex/card.rb",
    "lib/real_ex/client.rb",
    "lib/real_ex/config.rb",
    "lib/real_ex/initializer.rb",
    "lib/real_ex/recurring.rb",
    "lib/real_ex/response.rb",
    "lib/real_ex/transaction.rb",
    "lib/realex.rb",
    "realex.gemspec",
    "spec/address_spec.rb",
    "spec/card_spec.rb",
    "spec/config_spec.rb",
    "spec/real_ex_spec.rb",
    "spec/recurring_spec.rb",
    "spec/response_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/transaction_spec.rb"
  ]
  s.homepage = "http://github.com/paulca/realex"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Ruby interface to http://realexpayments.com"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency 'nokogiri', '~> 1.4', '>= 0'
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_runtime_dependency 'nokogiri', '~> 1.4', '>= 0'
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_runtime_dependency 'nokogiri', '~> 1.4', '>= 0'
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end
