node[:deploy].each do |application, deploy|

  Chef::Log.info("Restarting snowplow_stream_collector...")

  env = deploy["environment"]
  deploy_to = File.join(deploy["deploy_to"], "current")

  god_monitor "snowplow_stream_collector" do
    deploy_to deploy_to
    env env
    action :nothing
  end
end