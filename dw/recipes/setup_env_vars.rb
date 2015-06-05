include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  env = deploy["environment"]
  deploy_to = deploy["deploy_to"]
  dot_env_file = "#{deploy_to}/current/.env"

  Chef::Log.info("Generaing .env file...")
  template dot_env_file do
    source "env.erb"
    owner "root"
    group "root"
    mode 0755
    variables(
      :env_vars => env
    )
  end
end
