#
# Cookbook Name:: company-news
# Recipe:: default
#
# Copyright 2015, Shaun O'Keefe
#
include_recipe 'nginx'

nginx_site 'default' do
    enable false
end

nginx_site 'company_news' do
  template 'nginx.erb'
  variables({
     :app_server_ips => node['company-news']['nginx']['app_server_ips']
  })
end

%w[ /etc/nginx/ssl /etc/nginx/ssl/companynews.com ].each do |d|
  directory d do
    owner node['nginx']['user']
    group node['nginx']['group']
    action :create
  end
end

certs_databag =  data_bag_item('companynews', 'certs')
%w(crt key).each do |ext|
  file "/etc/nginx/ssl/companynews.com/server.#{ext}" do
    owner node['nginx']['user']
    group node['nginx']['group']
    action :create
    mode '0600'
    content certs_databag[ext]
  end
end
