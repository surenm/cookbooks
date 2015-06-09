Chef::Log.info("Updating pip to the latest version")
execute "/usr/bin/pip install -U pip" do
  user "root"
  only_if { ::File.exists?('/usr/bin/pip')}
  action :run
end
execute "/usr/local/bin/pip install -U pip" do
  user "root"
  only_if { ::File.exists?('/usr/local/bin/pip')}
  action :run
end
