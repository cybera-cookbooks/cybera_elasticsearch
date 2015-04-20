
if node[:roles].include?("elasticsearch-client")
  # TODO: install management plugin
  # /usr/share/elasticsearch/bin/plugin -i lmenezes/elasticsearch-kopf
  # /usr/share/elasticsearch/bin/plugin --remove lmenezes/elasticsearch-kopf
  # TODO: install curator (requires python-pip)

  sensu_gem "elasticsearch" do
    action :install
  end

  lmc_sensu_check "elasticsearch_cluster_is_healthy" do
    command     "check-elasticsearch-health.rb"
    handlers    ["lmc_alerting"]
    interval    60
  end
end


