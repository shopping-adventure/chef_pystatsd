# Install and configure pystatsd from https://github.com/sivy/pystatsd
# Deb package has been previously build

cookbook_file "python-statsd_1.0-4_all.deb" do
  path "/tmp/python-statsd_1.0-4_all.deb"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

package "python-support"

dpkg_package "python-statsd_1.0-4_all.deb" do
  source "/tmp/python-statsd_1.0-4_all.deb"
  action :install
  not_if "dpkg -l |grep python-statsd|grep 1.0-4"
end

service "pystatsd" do
  service_name "pystatsd"
  supports     :status => true, :restart => true, :reload => true
  action       [:enable, :start]
  provider     Chef::Provider::Service::Upstart
  only_if { ::File.exists?("/etc/init/pystatsd.conf")}
end

if node["graphite"]["pystatsd"]["type"] == "graphite"
  graphite=search(:node,"role:graphite_server AND chef_environment:#{node.chef_environment}").first
end

template "/etc/default/pystatsd" do
  source 'default_pystatsd.erb'
  owner 'root'
  group 'root'
  mode '0644'
  if node["graphite"]["pystatsd"]["type"] == "graphite"
    variables :graphite => graphite 
  end
  notifies :restart, 'service[pystatsd]'
end

template "/etc/init/pystatsd.conf" do
  source 'init_pystatsd.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[pystatsd]'
end
