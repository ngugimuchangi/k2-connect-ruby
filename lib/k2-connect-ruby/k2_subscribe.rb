class K2Subscribe
  include(K2ConnectRuby)
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
                :postman_k2_mock_server

  # Intialize with the event_type
  def initialize (event_type)
    raise K2NilEvent.new if event_type.nil?
    @event_type = event_type
  rescue K2NilEvent => k2
    puts k2.message
  rescue StandardError => e
    puts e.message
  end

  # Method for sending the request to K2 sandbox or Mock Server (Receives the access_token)
  def token_request(client_id, client_secret)
    token_params = {
        client_id: client_id,
        client_secret: client_secret,
        grant_type: "client_credentials"
    }
    token_hash = {
        :path_url => "ouath",
        :access_token =>  @subscriber_access_token,
        :is_get_request => false,
        :is_subscription => true,
        :params => token_params
    }
    @subscriber_access_token = K2Connect.to_connect(token_hash)
    # @subscriber_access_token = K2ConnectRuby.to_connect(token_params, "ouath", @subscriber_access_token, true, false)
  end

  # Implemented a Case condition that minimises repetition
  def webhook_subscribe
    case
      # Buygoods Received
    when @event_type.match?("buygoods_transaction_received")
      @k2_request_body = {
          event_type: "buygooods_transaction_received",
          url: "https://myapplication.com/webhooks",
          secret: "webhook_secret"
      }
      subscribe_hash = {
          :path_url => "webhook-subscription",
          :access_token =>  @subscriber_access_token,
          :is_get_request => false,
          :is_subscription => true,
          :params => @k2_request_body
      }
      K2Connect.to_connect(subscribe_hash)

      # Buygoods Reversed
    when @event_type.match?("buygoods_transaction_reversed")
      @k2_request_body = {
          event_type: "buygooods_transaction_reversed",
          url: "https://myapplication.com/webhooks",
          secret: "webhook_secret"
      }
      subscribe_hash = {
          :path_url => "buygoods-transaction-reversed",
          :access_token =>  @subscriber_access_token,
          :is_get_request => false,
          :is_subscription => true,
          :params => @k2_request_body
      }
      K2Connect.to_connect(subscribe_hash)

      # Customer Created.
    when @event_type.match?("customer_created")
      @k2_request_body = {
          event_type: "customer_created",
          url: "https://myapplication.com/webhooks",
          secret: "webhook_secret"
      }
      subscribe_hash = {
          :path_url => "customer-created",
          :access_token =>  @subscriber_access_token,
          :is_get_request => false,
          :is_subscription => true,
          :params => @k2_request_body
      }
      K2Connect.to_connect(subscribe_hash)

      # Settlement Transfer Completed
    when @event_type.match?("settlement_transfer_completed")
      @k2_request_body = {
          event_type: "settlement",
          url: "https://myapplication.com/webhooks",
          secret: "webhook_secret"
      }
      subscribe_hash = {
          :path_url => "settlement",
          :access_token =>  @subscriber_access_token,
          :is_get_request => false,
          :is_subscription => true,
          :params => @k2_request_body
      }
      K2Connect.to_connect(subscribe_hash)
    else
      raise K2NonExistentSubscription.new
    end
  rescue K2NonExistentSubscription => k2
    puts(k2.message)
  rescue StandardError => e
    puts(e.message)
  end
end