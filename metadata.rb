name             'haproxy-ng'
maintainer       'VINTED'
maintainer_email 'sre@vinted.com'
license          'apache2'
description      'modern, resource-driven cookbook for managing haproxy'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/vinted/chef-haproxy-ng'
issues_url       'https://github.com/vinted/chef-haproxy-ng/issues'
version          '0.5.3'

%w( fedora redhat centos scientific ubuntu ).each do |platform|
  supports platform
end

depends 'apt'
depends 'ark'
