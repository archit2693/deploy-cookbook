name 'test'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures test'
long_description 'Installs/Configures test'
version '0.1.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

depends 'tar'
depends 'postgresql'
