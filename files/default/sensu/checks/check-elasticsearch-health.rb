#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'elasticsearch'

class CheckElasticsearchHealth < Sensu::Plugin::Check::CLI
  def run
    client = Elasticsearch::Client.new
    health_status = client.cluster.health

    message = <<-EOF
Health state is degraded (yellow).
Active Primary Shards: #{health_status["active_primary_shards"]}
Active Shards: #{health_status["active_shards"]}
Unassigned Shards: #{health_status["unassigned_shards"]}
EOF

    if health_status["status"] == "green"
      ok
    elsif health_status["status"] == "yellow"
      warning message
    elsif health_status["status"] == "red"
      critical message
    else
      unknown message
    end
  end
end
