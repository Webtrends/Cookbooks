#
# Cookbook Name:: hadoop
# Recipe:: jobtracker
#
# Copyright 2012, Webtrends Inc.
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

include_recipe 'hadoop'

# is this dir actually used? -dvorak
#directory '/var/lib/hadoop/mapred' do
#	owner 'hadoop'
#	group 'hadoop'
#	mode 00700
#	recursive true
#	action :create
#end

# Create collectd plugin for hadoop jobtracker if collectd has been applied.
if node.attribute?('collectd')
	template "#{node[:collectd][:plugin_conf_dir]}/collectd_hadoop_JobTracker.conf" do
		source 'collectd_hadoop_JobTracker.conf.erb'
		owner 'root'
		group 'root'
		mode 00644
		notifies :restart, resources(:service => 'collectd')
	end
end
