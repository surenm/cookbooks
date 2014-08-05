# Set up app's custom configuration in the environment.
# See https://forums.aws.amazon.com/thread.jspa?threadID=118107

node[:deploy].each do |application, deploy|

  custom_env_template do
    application application
    deploy deploy
    env node[:custom_env][application]

    if node[:opsworks][:instance][:layers].include?('rails-app')
      notifies :run, resources(:execute => "restart Rails app #{application} for custom env")
    end
  end

end
