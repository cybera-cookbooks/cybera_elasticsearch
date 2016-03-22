#
# Cookbook Name:: cybera_elasticsearch
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
include_recipe "java"

# Install ElasticSearch and set up service
version = node[:elasticsearch][:version]
apt_repository "elasticsearch" do
  uri "http://packages.elasticsearch.org/elasticsearch/#{version}/debian"
  distribution "stable"
  components ["main"]
  key "http://packages.elasticsearch.org/GPG-KEY-elasticsearch"
  action :add
end
include_recipe "apt"
package "elasticsearch"
service "elasticsearch" do
  supports restart: true, start: true, stop: true, status: true
  action :enable
end

# Override appropriate variables for init script
template "/etc/default/elasticsearch" do
  source "default_elasticsearch.erb"
  mode 0755
  variables({
    :heap_size => "#{node[:memory][:total].to_i / 2}k"
  })
  notifies :restart, "service[elasticsearch]", :delayed
  action :create
end

# What kind of node are we?
data_nodes = search(:node, "role:elasticsearch-data")
master_nodes = search(:node, "role:elasticsearch-master")

# get data paths, but we only want it for data nodes
if node[:roles].include?("elasticsearch-data")
  data_paths = node[:elasticsearch][:path][:data]
  data_paths.each do |path|
    directory path do
      owner "elasticsearch"
      group "elasticsearch"
      mode "0775"
      recursive true
    end
  end
else
  data_paths = nil
end

template "/etc/elasticsearch/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  mode 0755
  variables({
    :data_path => data_paths,
    :http_enabled => node[:roles].include?("elasticsearch-client"),
    :is_data_node => node[:roles].include?("elasticsearch-data"),
    :is_master_node => node[:roles].include?("elasticsearch-master"),
    :minimum_master_nodes => master_nodes.length/2 + 1,
    :master_nodes => master_nodes.map {|n| n[:ipaddress]},
    :number_of_data_nodes => data_nodes.length,
    :number_of_master_nodes => master_nodes.length,
  })
  notifies :restart, "service[elasticsearch]", :delayed
  action :create
end

include_recipe "cybera_elasticsearch::client"

service "elasticsearch" do
  action :start
end

lmc_sensu_check "elasticsearch_is_running" do
  command     "check-procs.rb"
  args        "-p elasticsearch"
  handlers    ["lmc_alerting"]
  interval    60
  upload_file false
end

