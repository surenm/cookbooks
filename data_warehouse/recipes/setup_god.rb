gem_package "god" do
  action :install
  gem_binary "/usr/bin/gem"
end

directory "/etc/god/conf.d" do
  recursive true
  owner "root"
  group "root"
  mode 0755
end

template "/etc/god/master.god" do
  source "master.god.erb"
  owner "root"
  group "root"
  mode 0755
end

template "/etc/init.d/god" do
  source "god.init.erb"
  owner "root"
  group "root"
  mode 0755
end

service "god" do
  supports :status => true
  action :start
end