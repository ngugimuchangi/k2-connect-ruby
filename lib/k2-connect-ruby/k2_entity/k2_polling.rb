module K2ConnectRuby
  module K2Entity
    class K2Polling
      include K2ConnectRuby::K2Utilities::K2Validation, K2ConnectRuby::K2Utilities
      attr_reader :location_url, :k2_response_body
      attr_accessor :access_token

      # Initialize with access token
      def initialize(access_token)
        raise ArgumentError, 'Nil or Empty Access Token Given!' if access_token.blank?
        @access_token = access_token
      end

      def poll(params)
        k2_request_body = {
          scope: params[:scope],
          scope_reference: params[:scope_reference],
          from_time: params[:from_time],
          to_time: params[:to_time],
          _links: { callback_url: params[:callback_url] }
        }
        poll_hash = make_hash(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('poll'), 'post', @access_token,'Polling', k2_request_body)
        @location_url =  K2ConnectRuby::K2Utilities::K2Connection.make_request(poll_hash)
      end

      # Retrieve your newly created polling request by its resource location
      def query_resource(location_url = @location_url)
        query_hash = make_hash(location_url, 'get', @access_token, 'Polling', nil)
        @k2_response_body = K2ConnectRuby::K2Utilities::K2Connection.make_request(query_hash)
      end

      # Retrieve your newly created polling request by specific resource location
      def query_resource_url(url)
        query_resource(url)
      end
    end
  end
end
