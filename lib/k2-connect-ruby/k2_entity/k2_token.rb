module K2ConnectRuby
  module K2Entity
    class K2Token
      attr_reader :access_token, :token_response

      def initialize(client_id, client_secret)
        validate_client_credentials(client_id, client_secret)
        @client_id = client_id
        @client_secret = client_secret
      end

      def request_token
        token_params = {
          client_id: @client_id,
          client_secret: @client_secret,
          grant_type: 'client_credentials'
        }
        token_hash = K2ConnectRuby::K2Entity::K2Token.make_hash(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('oauth_token'), 'post', 'Access Token', token_params)
        @access_token = K2ConnectRuby::K2Utilities::K2Connection.make_request(token_hash)
      end

      def revoke_token(access_token)
        token_params = {
          client_id: @client_id,
          client_secret: @client_secret,
          token: access_token
        }
        token_hash = K2ConnectRuby::K2Entity::K2Token.make_hash(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('revoke_token'), 'post', 'Access Token', token_params)
        @token_response = K2ConnectRuby::K2Utilities::K2Connection.make_request(token_hash)
      end

      def introspect_token(access_token)
        token_params = {
          client_id: @client_id,
          client_secret: @client_secret,
          token: access_token
        }
        token_hash = K2ConnectRuby::K2Entity::K2Token.make_hash(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('introspect_token'), 'post', 'Access Token', token_params)
        @token_response = K2ConnectRuby::K2Utilities::K2Connection.make_request(token_hash)
      end

      def token_info(access_token)
        token_hash = K2ConnectRuby::K2Entity::K2Token.make_hash(K2ConnectRuby::K2Utilities::Config::K2Config.path_url('token_info'), 'get', 'Access Token', nil, false)

        token_hash[:access_token] = access_token
        @token_response = K2ConnectRuby::K2Utilities::K2Connection.make_request(token_hash)
      end

      def validate_client_credentials(client_id, client_secret)
        raise ArgumentError, 'Nil or Empty Client Id or Secret!' if client_id.blank? || client_secret.blank?
      end

      class << K2ConnectRuby::K2Entity::K2Token
        # Create a Hash containing important details accessible for K2Connect
        def make_hash(path_url, request, class_type, body, requires_token = true)
          {
            path_url: path_url,
            request_type: request,
            class_type: class_type,
            requires_token: requires_token,
            params: body
          }.with_indifferent_access
        end
      end
    end
  end
end
