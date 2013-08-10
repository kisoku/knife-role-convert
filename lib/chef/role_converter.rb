#
# Author:: Mathieu Sauve-Frankel <msf@kisoku.net>
# Copyright:: Copyright (c) 2013 Mathieu Sauve-Frankel
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'erubis'
require 'chef/role'

class Chef
  class RoleConverter
    RECIPE_TEMPLATE = File.join(File.dirname(__FILE__), "role_converter", "templates", "recipe.erb")

    attr_reader :role, :cookbook, :recipe
    attr_accessor :attributes, :dependencies, :run_list

    def initialize(role, config={})
      @role = Chef::Role.from_disk(role)
      @config = config
      @recipe = config[:recipe] || @role.name
      @cookbook = config[:cookbook] || 'new_cookbook'
      @attributes = {
        'default' => [],
        'override' => []
      }
      @run_list = []
      @dependencies = []
    end

    def convert_role
      convert_attributes(role.default_attributes, "default")
      convert_attributes(role.override_attributes, "override")
      convert_runlist
    end

    def convert_attributes(attrs, type, parents=[])
      # XXX this whole bit stinks, redo it later
      attrs.each do |attribute, value|
        # detect hashes and recursively descend to the bottommost level of nesting
        if value.is_a? Hash
          # make a copy of the parent path and add our current location before recurring
          new_parents = parents.dup
          new_parents << attribute
          convert_attributes(value, type, new_parents)
        else
          attr_path = parents.map {|a| "['#{a}']" }.join() + "['#{attribute}']"
          attributes[type].push("node.#{type}#{attr_path} = #{value.pretty_inspect}")
        end
      end
    end

    def convert_runlist
      role.run_list.each do |entry|
        if entry.recipe?
          cookbook = entry.name.split("::").first
          unless dependencies.member? cookbook
            dependencies << cookbook
          end
          run_list.push("include_recipe '#{entry.name}'\n")
        elsif entry.role?
          # XXX process recursively ?
          run_list.push("# XXX detected role in run_list: #{entry.name}\n")
          run_list.push("# include_recipe 'role_cookbook::#{entry.name}'\n")
        end
      end
    end

    def generate_recipe
      convert_role
      template = IO.read(Chef::RoleConverter::RECIPE_TEMPLATE).chomp
      eruby = Erubis::Eruby.new(template)
      context = {
        :cookbook => cookbook,
        :recipe => recipe,
        :default_attributes => attributes['default'],
        :override_attributes => attributes['override'],
        :run_list => run_list
      }
      eruby.evaluate(context)
    end
  end
end
