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

# Tell java to use IPv4 insted of IPv6
node.default['tomcat']['java_options'] = '-Xmx128M -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses'

# Turn off SSL as we'll do SSL termination in Nginx
node.default['tomcat']['ssl_port'] = nil
node.default['tomcat']['ssl_proxy_port'] = nil

# Disable the AJP connector as we're not going to be using it
node.default['tomcat']['ajp_port'] = nil

include_recipe 'tomcat'

remote_file "#{node['tomcat']['webapp_dir']}/sample.war" do
  source 'https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war'
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode '0755'
  action :create
end

include_recipe 'nginx'

nginx_site 'company_news' do
  template 'nginx.erb'
end

%w[ /etc/nginx/ssl /etc/nginx/ssl/companynews.com ].each do |d|
  directory d do
    owner node['nginx']['user']
    group node['nginx']['group']
    action :create
  end
end

%w(crt key).each do |ext|
  cookbook_file "/etc/nginx/ssl/companynews.com/server.#{ext}" do
    source "server.#{ext}"
    owner node['nginx']['user']
    group node['nginx']['group']
    action :create
    mode '0600'
  end
end
