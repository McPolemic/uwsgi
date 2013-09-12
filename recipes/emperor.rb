#
# Cookbook Name:: uwsgi
# Recipe:: emperor
#
# Copyright 2013, Guilhem Lettron <guilhem@lettron.fr>
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

directory node['uwsgi']['emperor']['conf_dir'] do
  owner "root"
  group "root"
  mode "0755"
end

case node['uwsgi']['emperor']['service']
when "upstart"
  template "/etc/init/uwsgi.conf" do
    source "uwsgi_upstart.erb"
    owner "root"
    group "root"
    mode "0644"
    variables :config_dir => node['uwsgi']['emperor']['conf_dir']
    notifies :stop, "service[uwsgi]"
    notifies :start, "service[uwsgi]"
  end

  service "uwsgi" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
  end
end
