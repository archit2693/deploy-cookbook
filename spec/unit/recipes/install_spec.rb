require 'spec_helper'

describe 'test::install' do

  before(:each) do
    @runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') do |node|
    end
    allow_any_instance_of(Chef::HTTP).to receive(:get).and_return("{\"tag_name\":\"V1.0\"}")
  end
	context 'apt_repository' do
    it 'should add brightbox/ruby-ng in apt-rep' do
      chef_run = @runner.converge(described_recipe)
      expect(chef_run).to add_apt_repository('brightbox-ruby')
    end
  end  
end
