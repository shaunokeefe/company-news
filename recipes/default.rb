#
# Cookbook Name:: company-news
# Recipe:: default
#
# Copyright 2015, Shaun O'Keefe
#
node.default['java']['jdk_version'] = 7
include_recipe 'java'
