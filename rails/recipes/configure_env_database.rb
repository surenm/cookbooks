node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  Chef::Log.info("Trying to set database for #{rails_env} environment")
  Chef::Log.info("Environment variable for DATABASE_URL=#{node[:deploy][application][:environment_variables]['DATABASE_URL']}")
end
