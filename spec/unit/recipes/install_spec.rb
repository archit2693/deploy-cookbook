require 'spec_helper'

describe 'test::install' do

  before(:each) do
    @chef_runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') do |node|
    end
    @response = @chef_runner.converge(described_recipe)
    allow_any_instance_of(Chef::HTTP).to receive(:get).and_return("{\"tag_name\":\"V1.0\"}")
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
end
