name 'godeploy-cookbook'
maintainer 'Archit Joshi'
maintainer_email 'archit.j.aux@go-jek.com'
license 'All Rights Reserved'
description 'Installs/Configures godeploy'
long_description 'Installs/Configures godeploy'
version '0.3.17'
chef_version '>= 12.14' if respond_to?(:chef_version)

depends 'tar'
depends 'postgresql'
