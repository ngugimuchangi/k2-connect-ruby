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
                  :event_type

    # Intialize with the event_type
    def initialize (event_type)
      @event_type = event_type
    rescue Exception => e
      puts e.message
    end

    # Checks if access_token is valid
    def valid_access_token(access_token)
      raise K2Errors::K2AccessTokenError unless access_token.eql?(@subscriber_access_token)
    end

    # Checks if access_token is nil/empty
    def nil_access_token(access_token)
      raise K2Errors::K2NilAccessToken if access_token.nil?
    end

    # Checks if refresh_token is valid
    def valid_refresh_token(refresh_token)
      unless refresh_token.eql?(@subscriber_refresh_token)
        abort "Invalid Refresh Token!"
      end
    end

    def token_lifecycle?(token_start, token_end)
      token_start_secs = token_start.strftime("%S") + token_start.strftime("%k")*3600 + token_start.strftime("%M")*60
      token_end_secs = token_end.strftime("%S") + token_end.strftime("%k")*3600 + token_end.strftime("%M")*60
      # raise K2Errors::K2ExpiredToken if @valid_token_time.to_i <= token_end_secs.to_i-token_start_secs.to_i
      return true
    end

    # Method for sending the request to K2 sandbox or Mock Server (Receives the access_token)
    def token_request
      k2_url = URI.parse("https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io/ouath")
      k2_https = Net::HTTP.new(k2_url.host, k2_url.port)
      k2_https.use_ssl =true
      k2_https.verify_mode =OpenSSL::SSL::VERIFY_PEER
      k2_request =Net::HTTP::Post.new(k2_url)
      k2_request.add_field('Content-Type', 'application/json')
      k2_request.body = {
          "client_id": "1",
          "client_secret": "2",
          "grant_type": "client_credentials"
      }.to_json
      k2_response = k2_https.request(k2_request)
      puts("\nThe Response:\t#{k2_response.body.to_s}")
      # Add a method to fetch all the components of the response
      @subscriber_access_token = Yajl::Parser.parse(k2_response.body)["access_token"]
      puts("\nThe Access Token:\t#{@subscriber_access_token}")
      @valid_token_time = Yajl::Parser.parse(k2_response.body)["expires_in"]
      puts("\nExpires In:\t#{@valid_token_time} seconds.")
      @token_lifecycle_start = Time.now
      # @subscriber_refresh_token = Yajl::Parser.parse(k2_response.body)["refresh_token"]
      # puts("\nThe Refresh Token:\t#{@subscriber_refresh_token}")
    rescue Exception => e
      puts(e.message)
    end

    # Method for webhook subscribing general
    def the_webhook_subscribe(access_token, k2_uri, k2_request_body)
      valid_access_token(access_token) || nil_access_token(access_token) and return
      k2_https = Net::HTTP.new(k2_uri.host, k2_uri.port)
      k2_https.use_ssl =true
      k2_https.verify_mode =OpenSSL::SSL::VERIFY_PEER
      k2_request =Net::HTTP::Post.new(k2_uri)
      k2_request.add_field("Content-Type", "application/json")
      k2_request.add_field("Accept", "application/json")
      k2_request.add_field("Authorization", "Bearer #{access_token}")
      k2_request.body = k2_request_body
      k2_response = k2_https.request(k2_request)
      puts("\nThe Response:\t#{k2_response.body.to_s}")
    rescue Exception => e
      puts(e.message)
    end

    # A Case condition that minimises repetition
    def webhook_subscribe
      case
        # Buygoods Received
        when @event_type.to_s.include?("received")
          @k2_uri = URI.parse("https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io/webhook-subscription")
          @k2_request_body = {
              "event_type": "buygooods_transaction_received",
              "url": "https://myapplication.com/webhooks",
              "secret": "webhook_secret"
          }.to_json
          the_webhook_subscribe(@subscriber_access_token, @k2_uri, @k2_request_body)

        # Buygoods Reversed
        when @event_type.to_s.include?("reversed")
          @k2_uri = URI.parse("https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io/buygoods-transaction-reversed")
          @k2_request_body = {
              "event_type": "buygooods_transaction_reversed",
              "url": "https://myapplication.com/webhooks",
              "secret": "webhook_secret"
          }.to_json
          the_webhook_subscribe(@subscriber_access_token, @k2_uri, @k2_request_body)

        # Customer Created
        when @event_type.to_s.include?("customer")
          @k2_uri = URI.parse("https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io/customer-created")
          @k2_request_body = {
              "event_type": "customer_created",
              "url": "https://myapplication.com/webhooks",
              "secret": "webhook_secret"
          }.to_json
          the_webhook_subscribe(@subscriber_access_token, @k2_uri, @k2_request_body)

        # Settlement Transfer Completed
        when @event_type.to_s.include?("settlement")
          @k2_uri = URI.parse("https://a54fac07-5ac2-4ee2-8fcb-e3d5ac3ba8b1.mock.pstmn.io/settlement")
          @k2_request_body = {
              "event_type": "settlement",
              "url": "https://myapplication.com/webhooks",
              "secret": "webhook_secret"
          }.to_json
          the_webhook_subscribe(@subscriber_access_token, @k2_uri, @k2_request_body)
      else
        raise K2Errors::K2NilSubscription
      end
    end

    # Get a refresh token
    def token_refresh(refresh_token)

    end

    #Class for Splitting the Responses
    # class Webhook_Split
    #   attr_accessor :webhook_topic,
    #                 :webhook_type,
    #                 :webhook_reference,
    #                 :webhook_msisdn,
    #                 :webhook_amount,
    #                 :webhook_currency,
    #                 :webhook_till_number,
    #                 :webhook_system,
    #                 :webhook_status,
    #                 :webhook_sender_first_name,
    #                 :webhook_sender_middle_name,
    #                 :webhook_sender_last_name
    #   # method for splitting the responses
    #   def split_response(webhook_response)
    #     @webhook_topic = webhook_response.dig("topic")
    #     @webhook_type = webhook_response.dig("event", "type")
    #     @webhook_reference = webhook_response.dig("event", "resource", "reference")
    #     @webhook_msisdn = webhook_response.dig("event", "resource", "sender_msisdn")
    #     @webhook_amount = webhook_response.dig("event", "resource", "amount")
    #     @webhook_currency = webhook_response.dig("event", "resource", "currency")
    #     @webhook_till_number = webhook_response.dig("event", "resource", "till_number")
    #     @webhook_system = webhook_response.dig("event", "resource", "system")
    #     @webhook_status = webhook_response.dig("event", "resource", "status")
    #     @webhook_sender_first_name = webhook_response.dig("event", "resource", "sender_first_name")
    #     @webhook_sender_middle_name = webhook_response.dig("event", "resource", "sender_middle_name")
    #     @webhook_sender_last_name = webhook_response.dig("event", "resource", "sender_last_name")
    #   rescue Exception => e
    #     puts(e.message)
    #   end
    # end

  end
end
