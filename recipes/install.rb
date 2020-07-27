#
# Cookbook Name:: haproxy-ng
# Recipe:: install
#
# Copyright 2015 Nathan Williams
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

case node['haproxy']['install_method']
when 'package'
  package 'haproxy'
when 'ppa'
  apt_repository 'haproxy' do
    uri node['haproxy']['ppa']['uri']
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key node['haproxy']['ppa']['key']
  end

  package 'haproxy'
when 'source'
  src = node['haproxy']['source']

  src['dependencies'].each do |dep|
    package dep
  end

  directory '/etc/haproxy'

  user 'haproxy' do
    home '/var/lib/haproxy'
    shell '/usr/sbin/nologin'
    system true
  end

  directory '/var/lib/haproxy' do
    owner 'haproxy'
    group 'haproxy'
  end

  ark 'haproxy' do
    url src['url']
    version src['url'].match(/(\d+\.?){2}\d+/).to_s
    checksum src['checksum']
    make_opts src['make_args'].map { |k, v| "#{k}=#{v}" }
    action :install_with_make
  end

  cookbook_file '/etc/init/haproxy.conf' do
    source 'haproxy.conf'
    mode '0644'
    only_if { File.directory?('/etc/init') }
  end

  cookbook_file '/etc/systemd/system/haproxy.service' do
    source 'haproxy.service'
    only_if { File.directory?('/etc/systemd/system') }
    not_if { File.directory?('/etc/init') }
  end
else
  Chef::Log.warn 'Unknown install_method for haproxy. Skipping install!'
end
