require 'spec_helper'

describe 'godeploy::install' do

  before(:each) do
    @chef_runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') do |node|
    	node.automatic['environment_variables'] =  {
                       Sample_key: 'value'
                     }
    end
    allow_any_instance_of(Chef::HTTP).to receive(:get).and_return("{\"tag_name\":\"v1.0\"}")
    @response = @chef_runner.converge(described_recipe)
  end

	context 'apt_repository' do
    it 'should add brightbox/ruby-ng in apt-rep' do
      expect(@response).to add_apt_repository('brightbox-ruby')
    end
  end  

  context 'apt_update' do
    it 'should update apt repository' do
      expect(@response).to update_apt_update('update')
    end
  end

  context 'package install' do
    it 'should install packages software-properties-common, ruby2.5, nodejs, build-essential, zlib1g-dev, liblzma-dev, libpq-dev' do
      expect(@response).to install_package(%w(software-properties-common ruby2.5 nodejs build-essential zlib1g-dev liblzma-dev libpq-dev))
    end
  end

  context 'gem_package' do
    it 'should install bundler' do
      expect(@response).to install_gem_package('bundler')
    end

    it 'should install rails' do
      expect(@response).to install_gem_package('rails')
    end

    it 'should install rake' do
      expect(@response).to install_gem_package('rake')
    end
  end

  context 'user' do
    it 'should create a user with attributes' do
      expect(@response).to create_user('deploy').with(uid: 1111, home: '/home/deploy', manage_home: true, shell: '/bin/bash')
    end
  end

  context 'directory' do
    it 'should create a release dir /home/deploy/v1.0' do
      expect(@response).to create_directory('/home/deploy/v1.0').with(
        owner:     'deploy',
        recursive: true
      )
	  end
	end

	context 'config file' do
    it 'should create a deploy.conf file in dir /etc/default/' do
      expect(@response).to create_file('/etc/default/deploy.conf').with(
        owner:     'deploy'
      )
	  end
	end

	context 'script file' do
    it 'should create a deploy_start.sh file in dir /home/deploy/' do
      expect(@response).to create_template('/home/deploy/deploy_start.sh').with(
        owner:     'deploy'
      )
	  end
	end

	context 'service file' do
    it 'should create a godeploy.service file in dir /etc/systemd/system' do
      expect(@response).to create_template('/etc/systemd/system/godeploy.service').with(
        owner:     'deploy'
      )
	  end
	end
end
