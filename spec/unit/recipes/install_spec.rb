require 'spec_helper'

describe 'test::install' do

  before(:each) do
    @chef_runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') do |node|
    end
    allow_any_instance_of(Chef::HTTP).to receive(:get).and_return("{\"tag_name\":\"V1.0\"}")
  end

	context 'apt_repository' do
    it 'should add brightbox/ruby-ng in apt-rep' do
      response = @chef_runner.converge(described_recipe)
      expect(response).to add_apt_repository('brightbox-ruby')
    end
  end  

  context 'apt_update' do
    it 'updates apt repo' do
      response = @chef_runner.converge(described_recipe)
      expect(response).to update_apt_update('update')
    end
  end
end
