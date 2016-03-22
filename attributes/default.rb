# Java 7 is currently recomended for Elastic Search
default.java[:jdk_version] = '8'
default[:java][:oracle][:accept_oracle_download_terms] = true
default[:java][:accept_license_agreement] = true
default[:java][:install_flavor] = "oracle"

default[:elasticsearch][:version] = "1.7"
default[:elasticsearch][:cluster][:name] = "elasticsearch"
default[:elasticsearch][:node][:name] = node[:hostname]
default[:elasticsearch][:node][:master] = true
default[:elasticsearch][:node][:data] = true
default[:elasticsearch][:index][:number_of_shards] = 5
default[:elasticsearch][:index][:number_of_replicas] = 1
default[:elasticsearch][:http][:enabled] = true
