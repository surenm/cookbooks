include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  env = deploy["environment"]

  deploy_to = deploy["deploy_to"]
  current_path = File.join deploy_to, 'current'

  Chef::Log.info("Generating config.hocon for collector...")
  template "#{deploy_to}/current/collector/config.hocon" do
    source "config.hocon.erb"
    owner "root"
    group "root"
    mode 0755
    variables(
        :aws_region => env["AWS_REGION"],
        :kinesis_stream_name => env["KINESIS_STREAM_NAME"]
    )
  end

  Chef::Log.info("Adding snowplow_stream_collector config for god...")

  god_monitor "snowplow_stream_collector" do
    current_path current_path
    env env
    action :nothing
  end
end
