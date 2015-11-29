#
# Cookbook Name:: company-news
# Recipe:: default
#
# Copyright 2015, Shaun O'Keefe
#
node.default['java']['jdk_version'] = 7
include_recipe 'java'

node.default['tomcat']['base_version'] = 7
# NOTE: (shauno) The Tomcat cookbook is designed to be used with
# roles but we're using a wrapper cookbook. One side effect of this is
# that if we update an attribute that is used to set subsequent attributes
# (e.g. base_version) then all the attributes need to be manually updated
# NOTE: (shauno) the below updates are based on the attributes for debian in the
# Tomcat cookbooks attributes file
node.default['tomcat']['base_instance'] = "tomcat#{node['tomcat']['base_version']}"
node.default['tomcat']['packages'] = ["tomcat#{node['tomcat']['base_version']}"]
node.default['tomcat']['deploy_manager_packages'] = ["tomcat#{node['tomcat']['base_version']}-admin"]

node.default['tomcat']['user'] = "tomcat#{node['tomcat']['base_version']}"
node.default['tomcat']['group'] = "tomcat#{node['tomcat']['base_version']}"
node.default['tomcat']['home'] = "/usr/share/tomcat#{node['tomcat']['base_version']}"
node.default['tomcat']['base'] = "/var/lib/tomcat#{node['tomcat']['base_version']}"
node.default['tomcat']['config_dir'] = "/etc/tomcat#{node['tomcat']['base_version']}"
node.default['tomcat']['log_dir'] = "/var/log/tomcat#{node['tomcat']['base_version']}"
node.default['tomcat']['tmp_dir'] = "/tmp/tomcat#{node['tomcat']['base_version']}-tmp"
node.default['tomcat']['work_dir'] = "/var/cache/tomcat#{node['tomcat']['base_version']}"
node.default['tomcat']['context_dir'] = "#{node['tomcat']['config_dir']}/Catalina/localhost"
node.default['tomcat']['webapp_dir'] = "/var/lib/tomcat#{node['tomcat']['base_version']}/webapps"
node.default['tomcat']['java_options'] = '-Xmx128M -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses'
include_recipe 'tomcat'
