class Github
	def initialize(repository_name)
		@url = "https://api.github.com/repos/#{repository_name}/releases/latest"
	end

	def get_release_file
		latest_release = JSON.parse(Chef::HTTP.new(@url).get(''))
    return latest_release['assets'].first['browser_download_url'] if latest_release.key?('assets')
    return ''
	end

	def get_release_name
		latest_release = JSON.parse(Chef::HTTP.new(@url).get(''))
    return latest_release['tag_name'] if latest_release.key?('tag_name')
    return ''
  end
end