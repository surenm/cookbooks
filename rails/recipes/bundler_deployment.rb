node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  Chef::Log.info("Bundling with --deployment option")

  execute 'bundle install --deployment' do
    cwd current_path
    user 'deploy'
    command 'bundle install --deployment --without development test'
    environment 'RAILS_ENV' => rails_env
  end
end
