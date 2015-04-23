
if node[:roles].include?("elasticsearch-client")
  # TODO: install management plugin
  # /usr/share/elasticsearch/bin/plugin -i lmenezes/elasticsearch-kopf
  # /usr/share/elasticsearch/bin/plugin --remove lmenezes/elasticsearch-kopf
  package "python-pip"
  python_pip "elasticsearch-curator"
  if node[:roles].include?("elasticsearch-client-management")
    cron "delete_old_elasticsearch_indices" do
      command "curator delete indices --older-than 120 --time-unit days --timestring '%Y.%m.%d'"
      hour "1"
      minute "0"
    end
  end

  sensu_gem "elasticsearch" do
    action :install
  end

  lmc_sensu_check "elasticsearch_cluster_is_healthy" do
    command     "check-elasticsearch-health.rb"
    handlers    ["lmc_alerting"]
    interval    60
  end
end


