default.java[:jdk_version] = '8'
default[:java][:oracle][:accept_oracle_download_terms] = true
default[:java][:accept_license_agreement] = true
default[:java][:install_flavor] = "oracle"

# You will likely want to override some of these. You'll want to make the cluster name unique
# so that nodes are not accidentally added to the cluster.
default[:elasticsearch][:cluster][:name] = "elasticsearch"
default[:elasticsearch][:node][:name] = node[:hostname]
default[:elasticsearch][:node][:master] = true   # node can be master
default[:elasticsearch][:node][:data] = true     # node stores data
default[:elasticsearch][:http][:enabled] = true  # node exposes REST API

# It seems like this is best overridden in the cluster itself using the management API.
default[:elasticsearch][:index][:number_of_shards] = 5
default[:elasticsearch][:index][:number_of_replicas] = 1
