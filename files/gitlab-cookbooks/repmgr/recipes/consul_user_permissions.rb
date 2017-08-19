#
# Copyright:: Copyright (c) 2017 GitLab Inc.
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
account_helper = AccountHelper.new(node)

postgresql_user account_helper.consul_user do
  notifies :run, "execute[grant read only access to repmgr]"
end

select_query = %(GRANT SELECT ON ALL TABLES IN SCHEMA repmgr_#{node['repmgr']['cluster']} TO "#{node['consul']['user']}")
usage_query = %(GRANT USAGE ON SCHEMA repmgr_#{node['repmgr']['cluster']} TO "#{node['consul']['user']}")

execute "grant read only access to repmgr" do
  command %(gitlab-psql gitlab_repmgr -c '#{select_query}; #{usage_query};')
  user account_helper.postgresql_user
  action :nothing
end
