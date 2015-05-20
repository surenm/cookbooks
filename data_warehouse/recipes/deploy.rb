include_recipe 'deploy'

node[:deploy].each do |application, deploy|
    env = deploy["environment"]
    deploy_to = deploy["deploy_to"]
    current_path = File.join deploy_to, 'current'
    
    Chef::Log.info("Deploying #{application}...")
    
    opsworks_deploy_dir do
        user deploy[:user]
        group deploy[:group]
        path deploy[:deploy_to]
    end

    opsworks_deploy do
        deploy_data deploy
        app application
    end
end