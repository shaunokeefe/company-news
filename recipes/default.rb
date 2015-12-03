#
# Cookbook Name:: company-news
# Recipe:: default
#
# Copyright 2015, Shaun O'Keefe
#
include_recipe 'company-news::app'
include_recipe 'company-news::nginx'
