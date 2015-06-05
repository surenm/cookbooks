Chef::Log.info("Updating pip to the latest version")
execute "/usr/bin/pip install -U pip" do
  user "root"
  action :run
end