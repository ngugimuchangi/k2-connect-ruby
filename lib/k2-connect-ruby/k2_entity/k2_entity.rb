# Common Class Behaviours for stk, pay and transfers
module K2ConnectRuby
  module K2Entity
    class K2Entity
      attr_accessor :access_token, :the_array
      attr_reader :k2_response_body, :query_hash, :location_url
      include K2ConnectRuby::K2Utilities::K2Validation, K2ConnectRuby::K2Utilities

      # Initialize with access token from Subscriber Class
      def initialize(access_token)
        @access_token = access_token
        @exception_array = %w[authenticity_token]
      end

      # Query/Check the status of a previously initiated request
      def query_status(class_type, path_url)
        query(class_type, path_url)
      end

      # Query Location URL
      def query_resource(class_type, url)
        query(class_type, url)
      end

      def query(class_type, path_url)
        path_url = validate_url(path_url)
        query_hash = make_hash(path_url, 'get', @access_token, class_type, nil)
        @k2_response_body = K2ConnectRuby::K2Utilities::K2Connection.make_request(query_hash)
      end
    end
  end
end
