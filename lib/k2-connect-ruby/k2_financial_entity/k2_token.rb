# Class for Gaining Access Token
class K2AccessToken
  attr_reader :access_token
  def initialize(client_id, client_secret)
    validate_client_credentials(client_id, client_secret)
    @client_id = client_id
    @client_secret = client_secret
  end

  # Method for sending the request to K2 sandbox or Mock Server (Receives the access_token)
  def request_token
    token_params = {
        client_id: @client_id,
        client_secret: @client_secret,
        grant_type: 'client_credentials'
    }
    token_hash = K2AccessToken.make_hash('oauth/token', 'POST', 'Access Token', token_params)
    @access_token = K2Connect.connect(token_hash)
  end

  def validate_client_credentials(client_id, client_secret)
    raise ArgumentError, 'Nil or Empty Client Id or Secret!' if client_id.blank? || client_secret.blank?
  end

  # Create a Hash containing important details accessible for K2Connect
  def self.make_hash(path_url, request, class_type, body)
    {
        path_url: path_url,
        request_type: request,
        class_type: class_type,
        params: body
    }.with_indifferent_access
  end
end