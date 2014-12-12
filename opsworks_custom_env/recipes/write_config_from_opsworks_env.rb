# Set up app's stack environment variables in the environment.
node[:deploy].each do |application, deploy|
  custom_env_template do
    application application
    deploy deploy
     env node[:deploy][application][:environment_variables]

    if node[:opsworks][:instance][:layers].include?('rails-app')
      notifies :run, resources(:execute => "restart Rails app #{application} for custom env")
    end
  end

end
