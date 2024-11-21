module K2ConnectRuby
  module K2Utilities
    module K2Connection
      extend self
      # Method for sending the request to K2 sandbox or Mock Server
      def make_request(connection_hash)
        access_token = connection_hash[:access_token]
        class_type = connection_hash[:class_type]
        path_url = connection_hash[:path_url]
        request_type = connection_hash[:request_type]
        requires_token = connection_hash[:requires_token]

        unless class_type.eql?('Access Token') || access_token.present?
          raise ArgumentError, 'No Access Token in Arguments!'
        end

        # Set up Headers
        headers = if requires_token
          { 'Content-Type': 'application/json', Accept: 'application/json', Authorization: "Bearer #{access_token}" }
        else
          { 'Content-Type': 'application/json' }
        end

        k2_response = RestClient::Request.execute(
          method: request_type,
          url: path_url,
          headers: headers,
          payload: connection_hash[:params].to_json
        )

        # Response Body
        response_body = JSON.parse(k2_response.body, symbolize_names: true) if k2_response.body.present?
        response_headers = JSON.parse(k2_response.headers.to_json, symbolize_names: true)
        response_code = k2_response.code.to_s
        raise K2ConnectRuby::K2ConnectionError.new(response_code) unless response_code.starts_with?("2")

        if request_type.eql?('get')
          response_body
        else
          # Returns the access token for authorization
          return response_body[:access_token] if path_url.include?('oauth/token')

          response_headers[:location]
        end
      end
    end
  end
end
