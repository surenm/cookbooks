include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  env = deploy["environment"]
  deploy_to = deploy["deploy_to"]

  Chef::Log.info("Pip install dependencies from requirements.txt...")
  execute "/usr/bin/pip install -r #{deploy_to}/current/requirements.txt" do
    user "root"
    action :run
  end

  command_generator_script = "#{deploy_to}/current/kinesis_consumer/kcl_command_generator.py"
  consumer_properties_file = "#{deploy_to}/current/kinesis_consumer/consumer.properties"
  java_binary = `which java`

  Chef::Log.info("Generating consumer.properties for Kinesis Consumer...")
  template consumer_properties_file do
    source "consumer.properties.erb"
    owner "root"
    group "root"
    mode 0755
    variables(
        :kinesis_stream_name => env["KINESIS_STREAM_NAME"],
        :aws_region => env["AWS_REGION"],
        :kinesis_consumer_script => "#{deploy_to}/current/kinesis_consumer/events_consumer.py",
        :kinesis_consumer_app_name => "EventsConsumer"
    )
  end

  Chef::Log.info("Adding consumer config for god...")
  command_generator = "#{command_generator_script} --print_command --java #{java_binary} --properties #{consumer_properties_file}"
  consumer_exe = `#{command_generator}`

  god_monitor "kinesis_consumer" do
    source "kinesis_consumer.god.erb"
    consumer_exe consumer_exe
    env env
    action :nothing
  end
end
