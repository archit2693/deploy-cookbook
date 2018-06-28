require 'spec_helper'
require_relative '../../../libraries/github'

describe 'Github' do
	before(:each) do
      @github = Github.new('ritik02/Deploy')
  end
  context 'get release_name' do
    context 'latest release contains tag_name' do
      it 'should return the tag_name' do
        allow_any_instance_of(Chef::HTTP).to receive(:get).and_return("{\"tag_name\":\"tag\"}")
        expect(@github.get_release_name).to eq('tag')
      end
    end

    context 'latest release does not contain tag_name' do
      it 'should return empty string' do
        allow_any_instance_of(Chef::HTTP).to receive(:get).and_return("{}")
        expect(@github.get_release_name).to eq('')
      end
    end
  end

  context 'get release_file' do
    context 'latest release contains assets' do
      it 'should return the download url' do
        allow_any_instance_of(Chef::HTTP).to receive(:get).and_return("{\"assets\":[{\"browser_download_url\":\"www.download.url\"}]}")
        expect(@github.get_release_file).to eq('www.download.url')
      end
    end

    context 'latest release does not contain assets' do
      it 'should return empty string' do
        allow_any_instance_of(Chef::HTTP).to receive(:get).and_return("{}")
        expect(@github.get_release_file).to eq('')
      end
    end
  end

end
