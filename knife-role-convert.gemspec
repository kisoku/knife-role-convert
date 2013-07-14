$:.unshift(File.dirname(__FILE__) + '/lib')
require 'chef/role_converter/version'

Gem::Specification.new do |s|
  s.name = "knife-role-convert"
  s.version = Chef::RoleConverter::VERSION
  s.license = 'Apache 2.0'
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.summary = "knife plugin for converting roles to recipes"
  s.description = s.summary
  s.author = "Mathieu Sauve-Frankel"
  s.email = "msf@kisoku.net"
  s.homepage = "http://github.com/kisoku/knife-role-convert"

  s.add_dependency "mixlib-cli", ">= 1.2.2"
  s.add_dependency 'chef'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'

  s.require_path = 'lib'
  s.files = %w(LICENSE README.rdoc Rakefile) + Dir.glob("{lib,spec}/**/*")
end
