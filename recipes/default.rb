#
# Cookbook Name:: radicale
# Recipe:: default
#

users = data_bag('users') rescue []  # If the users data bag doesn't exist
ulist = Hash.new

users.each do |id|
  userpass = data_bag_item('users', id)
  ulist[id] = userpass['password']
end

package "radicale" do
  action :upgrade
end

# Ensure log directory exists (If not radicale silently fails)
directory '/var/log/radicale/'

if node["platform"] == "ubuntu"
  cookbook_file "/etc/init/radicale.conf" do
    source "radicale.conf"
    owner "root"
    group "root"
    mode  "0644"
  end

  link "/etc/init.d/radicale" do
    to "/lib/init/upstart-job"
  end
end
  
service "radicale" do
  supports :status => true, :restart => true

  action [:enable,:start]
end

template "/etc/radicale/config" do
  source "config.erb"
  mode  0644
  owner "root"
  group "root"

  notifies :restart, "service[radicale]"
end

template "/etc/radicale/users" do
  source "users.erb"
  mode  0644
  owner "root"
  group "root"
  variables( :userlist => ulist )

  notifies :restart, "service[radicale]"
end
