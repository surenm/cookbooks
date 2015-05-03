node[:deploy].each do |application, deploy|

  Chef::Log.info("Restarting snowplow_stream_collector...")

  env = deploy["environment"]
  deploy_to = deploy["deploy_to"]

  god_monitor "snowplow_stream_collector" do
    deploy_to deploy_to
    env env
    action :nothing
  end
end