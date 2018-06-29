require 'spec_helper'

describe 'test::install' do

  before(:each) do
    @chef_runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') do |node|
    end
    allow_any_instance_of(Chef::HTTP).to receive(:get).and_return("{\"tag_name\":\"V1.0\"}")
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
  end

  context 'user' do
    it 'should create a user with attributes' do
      expect(@response).to create_user('godeploy').with(uid: 1111, home: '/opt/godeploy', manage_home: true, shell: '/bin/bash')
    end
  end
end
