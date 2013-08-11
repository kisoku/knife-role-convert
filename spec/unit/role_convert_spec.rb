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

require 'support/spec_helper.rb'

class Chef
  describe RoleConverter do
    describe "#initialize" do
      let(:simple_role) {
        RoleConverter.new("simple_role")
      }
      it "should load the role from disk" do
        simple_role.recipe.should eq "simple_role"
        simple_role.role.run_list.first.should be_a_kind_of Chef::RunList::RunListItem
        simple_role.role.run_list.first.name.should eq "foo"
      end

      it "process nested attributes" do
        simple_role.convert_attributes(simple_role.role.override_attributes, "override")
        simple_role.attributes['override'].should eq [
          "node.override['foo']['unicorn']['collect_tears'] = true\n",
          "node.override['foo']['unicorn']['nested']['should_not_inspect_the_contents'] = [{:lambda=>\"lambda\"}, {:lambda=>\"mu\"}]\n",
          "node.override['bar'] = 1\n",
          "node.override['baz'] = 2.2\n",
          "node.override['quux'] = [\"unos\", \"dos\", \"tres\"]\n"
        ]
      end
    end
  end
end
