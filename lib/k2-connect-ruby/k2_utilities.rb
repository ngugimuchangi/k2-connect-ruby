require 'k2-connect-ruby/k2_utilities/k2_url_parse'
require 'k2-connect-ruby/k2_utilities/k2_authenticator'
require 'k2-connect-ruby/k2_utilities/k2_connection'
require 'k2-connect-ruby/k2_utilities/k2_validation'
require 'k2-connect-ruby/k2_utilities/config/k2_config'
require 'k2-connect-ruby/k2_utilities/k2_process_result'
require 'k2-connect-ruby/k2_utilities/k2_process_webhook'

module K2ConnectRuby
  module K2Utilities
    def make_hash(path_url, request, access_token, class_type, body, requires_token = true)
      {
        path_url: path_url,
        access_token: access_token,
        request_type: request,
        requires_token: requires_token,
        class_type: class_type,
        params: body
      }.with_indifferent_access
    end
  end
end