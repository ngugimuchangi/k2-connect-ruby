module K2ConnectRuby
  class K2Subscribe
    attr_accessor :client_id,
                  :client_secret,
                  :k2_uri,
                  :k2_request_body,
                  :webhook_secret,
                  :subscriber_access_token,
                  :subscriber_refresh_token,
                  :valid_token_time,
                  :token_lifecycle,
                  :event_type,
                  :k2_response_token,
                  :k2_response_webhook,
                  :http_exceptions

    # Intialize with the event_type
    def initialize (event_type)
      raise K2NilEvent.new if event_type.nil?
      event_types = %w(buygoods_transaction_received, buygooods_transaction_reversed, customer_created, settlement_transfer_completed)
      raise K2InvalidEventType(event_types) unless event_types.include?(event_type)
      @event_type = event_type
      @http_exceptions = [ Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
                               Errno::EHOSTUNREACH, Net::ProtocolError, Net::OpenTimeout, Net::HTTPFatalError,
                               Net::HTTPHeaderSyntaxError, Net::HTTPServerException, OpenSSL::SSL::SSLError,
                               Net::HTTP::Persistent::Error, Net::HTTPRetriableError ]
    rescue K2NilEvent => k2
      puts k2.message
    rescue K2InvalidEventType => k3
      puts k3.message
    rescue StandardError => e
      puts e.message
    end

    # Method for sending the request to K2 sandbox or Mock Server (Receives the access_token)
    def token_request(client_id, client_secret)
      # Raised in the scenario that when requests for an access_token even though they already have one
      raise K2RepeatTokenRequest.new unless @subscriber_access_token.eql?nil

      k2_url = URI.parse("https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io/ouath")
      k2_https = Net::HTTP.new(k2_url.host, k2_url.port)
      k2_https.use_ssl =true
      k2_https.verify_mode =OpenSSL::SSL::VERIFY_PEER
      k2_request =Net::HTTP::Post.new(k2_url)
      k2_request.add_field('Content-Type', 'application/json')
      k2_request.body = {
          "client_id": "#{client_id}",
          "client_secret": "#{client_secret}",
          "grant_type": "client_credentials"
      }.to_json
      begin
        @k2_response_token = k2_https.request(k2_request)
      rescue @http_exceptions => e
        puts(e.message)
      rescue StandardError => se
        puts(se.message)
      end
      # @k2_response_token = k2_https.request(k2_request)
      puts("\nThe Response:\t#{@k2_response_token.body.to_s}")
      # Add a method to fetch all the components of the response
      @subscriber_access_token = Yajl::Parser.parse(@k2_response_token.body)["access_token"]
      puts("\nThe Access Token:\t#{@subscriber_access_token}")
      @valid_token_time = Yajl::Parser.parse(@k2_response_token.body)["expires_in"]
      puts("\nExpires In:\t#{@valid_token_time} seconds.")
      return true
    rescue StandardError => e
      puts(e.message)
      return false
    end

    # Method for webhook subscribing general
    def the_webhook_subscribe(access_token, k2_uri, k2_request_body)
      # Checks if access_token argument is nil/empty
      raise K2NilAccessToken.new if access_token.nil?

      k2_https = Net::HTTP.new(k2_uri.host, k2_uri.port)
      k2_https.use_ssl =true
      k2_https.verify_mode =OpenSSL::SSL::VERIFY_PEER
      k2_request =Net::HTTP::Post.new(k2_uri)
      k2_request.add_field("Content-Type", "application/json")
      k2_request.add_field("Accept", "application/json")
      k2_request.add_field("Authorization", "Bearer #{access_token}")
      k2_request.body = k2_request_body
      begin
        @k2_response_webhook = k2_https.request(k2_request)
      rescue @http_exceptions => e
        puts(e.message)
      rescue StandardError => se
        puts(se.message)
      end
      # @k2_response_webhook = k2_https.request(k2_request)
      puts("\nThe Response:\t#{@k2_response_webhook.body.to_s}")
    rescue StandardError => e
      puts(e.message)
    end

    # A Case condition that minimises repetition
    def webhook_subscribe
      case
        # Buygoods Received
        when @event_type.match?("buygoods_transaction_received")
          @k2_uri = URI.parse("https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io/webhook-subscription")
          @k2_request_body = {
              "event_type": "buygooods_transaction_received",
              "url": "https://myapplication.com/webhooks",
              "secret": "webhook_secret"
          }.to_json
          the_webhook_subscribe(@subscriber_access_token, @k2_uri, @k2_request_body)

        # Buygoods Reversed
        when @event_type.match?("buygoods_transaction_reversed")
          @k2_uri = URI.parse("https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io/buygoods-transaction-reversed")
          @k2_request_body = {
              "event_type": "buygooods_transaction_reversed",
              "url": "https://myapplication.com/webhooks",
              "secret": "webhook_secret"
          }.to_json
          the_webhook_subscribe(@subscriber_access_token, @k2_uri, @k2_request_body)

        # Customer Created.  Match the entire string
        when @event_type.match?("customer_created")
          @k2_uri = URI.parse("https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io/customer-created")
          @k2_request_body = {
              "event_type": "customer_created",
              "url": "https://myapplication.com/webhooks",
              "secret": "webhook_secret"
          }.to_json
          the_webhook_subscribe(@subscriber_access_token, @k2_uri, @k2_request_body)

        # Settlement Transfer Completed
        when @event_type.match?("settlement_transfer_completed")
          @k2_uri = URI.parse("https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io/settlement")
          @k2_request_body = {
              "event_type": "settlement",
              "url": "https://myapplication.com/webhooks",
              "secret": "webhook_secret"
          }.to_json
          the_webhook_subscribe(@subscriber_access_token, @k2_uri, @k2_request_body)
      else
        raise K2NonExistentSubscription.new
      end
    rescue K2NonExistentSubscription => k2
      puts(k2.message)
    rescue StandardError => e
      puts(e.message)
    end
  end
end
