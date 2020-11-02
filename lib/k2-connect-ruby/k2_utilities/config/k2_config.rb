# TODO: try to see if you can implement Environment variables
module K2Config
  puts(File.join('lib/k2-connect-ruby/k2_utilities/config/k2_config.yml'))
  puts(File.join('lib', 'k2-connect-ruby', 'k2_utilities', 'config', 'k2_config.yml'))
  @config = YAML.load_file(File.join('lib', 'k2-connect-ruby', 'k2_utilities', 'config', 'k2_config.yml')).with_indifferent_access

  # def yml_file_location(user_file_location)
  #   file_location = File.join('lib', 'k2-connect-ruby', 'k2_utilities', 'config', 'k2_config.yml') || user_file_location
  #   @config = YAML.load_file(file_location).with_indifferent_access
  # end
  #

  class << self
    # Set the Host Url
    def set_base_url(base_url)
      raise ArgumentError, 'Invalid URL Format.' unless base_url =~ /\A#{URI.regexp(%w[http https])}\z/
      @config[:base_url] = base_url
      File.open("lib/k2-connect-ruby/k2_utilities/config/k2_config.yml", 'w') { |f| YAML.dump(@config, f) }
    end

    # TODO: Versioning
    def set_version(version_number)
      raise ArgumentError, 'Invalid Format: Version Number input should be Numeric' unless version_number.is_a?(Numeric)
      @config[:version] = "v#{version_number}"
      File.open("lib/k2-connect-ruby/k2_utilities/config/k2_config.yml", 'w') { |f| YAML.dump(@config, f) }
    end

    def version
      @config[:version]
    end

    def path_endpoint(key)
      unless key.eql?('oauth_token')
        return "api/#{version}/#{@config[:endpoints][:"#{key}"]}"
      end
      @config[:endpoints][:"#{key}"]
    end

    def path_endpoints
      @config[:endpoints]
    end

    def path_url(key)
      # TODO: Custom error/exception message
      base_url + path_endpoint(key)
    end

    def network_operators
      @config[:network_operators]
    end

    private

    def base_url
      @config[:base_url]
    end
  end

end
