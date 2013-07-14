$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'chef/config'
require 'chef/role'
require 'chef/role_converter'

Chef::Config[:role_path] = File.join(File.dirname(__FILE__), '..', 'data', 'roles')
