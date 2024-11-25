module K2ConnectRuby
  module K2Utilities
    module Config
      module K2Config
        @config = YAML.load_file(File.join(File.dirname(__FILE__), 'k2_config.yml'), permitted_classes: [ActiveSupport::HashWithIndifferentAccess]).with_indifferent_access

        class << self
          # Set the Host Url
          def set_base_url(base_url)
            raise ArgumentError, 'Invalid URL Format.' unless base_url =~ /\A#{URI.regexp(%w[http https])}\z/
            @config[:base_url] = base_url
            File.open(File.join(File.dirname(__FILE__), 'k2_config.yml'), 'w') { |f| YAML.dump(@config, f) }
          end

          def set_version(version_number)
            raise ArgumentError, 'Invalid Format: Version Number input should be Numeric' unless version_number.is_a?(Numeric)
            @config[:version] = "v#{version_number}"
            File.open(File.join(File.dirname(__FILE__), 'k2_config.yml'), 'w') { |f| YAML.dump(@config, f) }
          end

          def version
            @config[:version]
          end

          def path_endpoint(key)
            unless key.include?('token')
              return "api/#{version}/#{@config[:endpoints][:"#{key}"]}"
            end
            @config[:endpoints][:"#{key}"]
          end

          def path_endpoints
            @config[:endpoints]
          end

          def path_url(key)
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
    end
  end
end
