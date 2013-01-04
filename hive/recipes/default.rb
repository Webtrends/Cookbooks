#
# Cookbook Name:: hive
# Recipe:: default
# Author:: Sean McNamara(<sean.mcnamara@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the hive

include_recipe 'hadoop'

# servers in this cluster
zookeeper_nodes = zookeeper_search('zookeeper').sort

# define easier to use variables
source_tarball  = node.hive_attrib(:download_url)[/\/([^\/\?]+)(\?.*)?$/, 1]
source_fullpath = File.join(Chef::Config[:file_cache_path], source_tarball)

# determine metastore jdbc properties
metastore_prefix = 'none'
metastore_driver = 'none'

if node.hive_attrib(:metastore, :connector) == 'mysql'
	metastore_prefix = 'mysql'
	metastore_driver = 'com.mysql.jdbc.Driver'
end

if node.hive_attrib(:metastore, :connector) == 'sqlserver'
	metastore_prefix = 'sqlserver'
	metastore_driver = 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
end

# download hive
remote_file source_fullpath do
	source node.hive_attrib(:download_url)
	mode 00644
	not_if "test -f #{source_fullpath}"
end

# extract it
execute 'extract-hive' do
	command "tar -zxf #{source_fullpath}"
	creates "hive-#{node.hive_attrib(:version)}-bin"
	cwd "#{node.hadoop_attrib(:install_dir)}"
	user 'hadoop'
	group 'hadoop'
end

link '/usr/share/hive' do
	to "#{node.hadoop_attrib(:install_dir)}/hive-#{node.hive_attrib(:version)}-bin"
end

# jdbc connectors
%w[mysql-connector-java.jar sqljdbc4.jar].each do |jar|
	cookbook_file "/usr/share/hive/lib/#{jar}" do
		source "#{jar}"
		owner 'hadoop'
		group 'hadoop'
		mode 00644
	end
end

# load the databag to get the hive meta db authentication
auth_config = data_bag_item('authorization', "#{node.chef_environment}")

# create the log directory
directory '/var/log/hive' do
	action :create
	owner 'hadoop'
	group 'hadoop'
	mode 00755
end

# create config files and the startup script from template
%w[hive-site.xml hive-env.sh hive-exec-log4j.properties hive-log4j.properties].each do |template_file|
	template "/usr/share/hive/conf/#{template_file}" do
		source "#{template_file}"
		mode 00755
		variables(
			:metastore_driver => metastore_driver,
			:dbuser => auth_config['hive']['dbuser'],
			:dbpass => auth_config['hive']['dbpass']
		)
	end

	# remove default template files
	file "/usr/share/hive/conf/#{template_file}.template" do
		action :delete
	end
end

# remove old jars
%w[hbase-0.89.0-SNAPSHOT.jar hbase-0.89.0-SNAPSHOT-tests.jar].each do |template_file|
	file "/usr/share/hive/lib/#{template_file}" do
		action :delete
	end
end

link "/usr/share/hive/lib/hbase-#{node.hbase_attrib(:version)}.jar" do
	owner 'hadoop'
	group 'hadoop'
	to "/usr/share/hbase/hbase-#{node.hbase_attrib(:version)}.jar"
end

# this is used in hive-env.sh
file '/etc/zookeeper' do
	owner 'root'
	group 'root'
	mode 00644
	content zookeeper_nodes.join("\n")
end
