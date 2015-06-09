include_recipe 'deploy'

node[:deploy].each do |application, deploy|
    env = deploy["environment"]
    deploy_to = deploy["deploy_to"]
    consumer_properties_file = "#{deploy_to}/current/kinesis_consumer/blast_stats_app_consumer.properties"
    command_generator_script = "#{deploy_to}/current/kinesis_consumer/kcl_command_generator.py"
    java_binary = `which java`.strip
    command_generator = "#{command_generator_script} --print_command --java #{java_binary} --properties #{consumer_properties_file}"

    Chef::Log.info("Pip install dependencies from requirements.txt...")
    execute "/usr/local/bin/pip install -r #{deploy_to}/current/requirements.txt" do
      user "root"
      action :run
    end

    Chef::Log.info("Generating consumer.properties for Kinesis Consumer...")
    template consumer_properties_file do
      source "consumer.properties.erb"
      owner "root"
      group "root"
      mode 0755
      variables(
          :kinesis_stream_name => env["KINESIS_STREAM_NAME"],
          :aws_region => env["AWS_REGION"],
          :kinesis_consumer_script => "#{deploy_to}/current/kinesis_consumer/blast_stats_app_consumer.py",
          :kinesis_consumer_app_name => "BlastStatsAppConsumer"
      )
    end

    Chef::Log.info("Adding consumer config for god...")

    ruby_block "Calculate the consumer executable..." do
      block do
        consumer_exe = `#{command_generator}`
      end
      action :run
    end

    god_monitor "kinesis_consumer" do
      source "kinesis_consumer.god.erb"
      consumer_exe consumer_exe
      env env
      action :nothing
    end
end
