node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  Chef::Log.info("bundle install --deployment --without #{deploy[:ignore_bundler_groups].join(' ')} --path #{deploy[:home]}/.bundler/#{application}")

  execute 'bundle install --deployment' do
    cwd current_path
    user 'deploy'
    
    command "bundle install --deployment --without #{deploy[:ignore_bundler_groups].join(' ')} --path #{deploy[:home]}/.bundler/#{application}"
    environment 'RAILS_ENV' => rails_env
  end
end
