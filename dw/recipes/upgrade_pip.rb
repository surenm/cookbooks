Chef::Log.info("Updating pip to the latest version")

ruby_block "Get Pip executable" do
  block do
    pip_executable = `which pip`
  end
  action :run
end

execute "#{pip_executable} install -U pip" do
  user "root"
  action :run
end