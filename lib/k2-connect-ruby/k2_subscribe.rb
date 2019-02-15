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
        "client_id": "#{client_id}",
        "client_secret": "#{client_secret}",
        "grant_type": "client_credentials"
    }.to_json
    @subscriber_access_token = K2ConnectRuby.to_connect(token_params, "/ouath", @subscriber_access_token, true, false)
  end

  # Implemented a Case condition that minimises repetition
  def webhook_subscribe
    case
      # Buygoods Received
    when @event_type.match?("buygoods_transaction_received")
      @k2_request_body = {
          "event_type": "buygooods_transaction_received",
          "url": "https://myapplication.com/webhooks",
          "secret": "webhook_secret"
      }.to_json
      K2ConnectRuby.to_connect(@k2_request_body, "/webhook-subscription", @subscriber_access_token, true, false)

      # Buygoods Reversed
    when @event_type.match?("buygoods_transaction_reversed")
      @k2_request_body = {
          "event_type": "buygooods_transaction_reversed",
          "url": "https://myapplication.com/webhooks",
          "secret": "webhook_secret"
      }.to_json
      K2ConnectRuby.to_connect(@k2_request_body, "/buygoods-transaction-reversed", @subscriber_access_token, true, false)

      # Customer Created.
    when @event_type.match?("customer_created")
      @k2_request_body = {
          "event_type": "customer_created",
          "url": "https://myapplication.com/webhooks",
          "secret": "webhook_secret"
      }.to_json
      K2ConnectRuby.to_connect(@k2_request_body, "/customer-created", @subscriber_access_token, true, false)

      # Settlement Transfer Completed
    when @event_type.match?("settlement_transfer_completed")
      @k2_request_body = {
          "event_type": "settlement",
          "url": "https://myapplication.com/webhooks",
          "secret": "webhook_secret"
      }.to_json
      K2ConnectRuby.to_connect(@k2_request_body, "/settlement", @subscriber_access_token, true, false)
    else
      raise K2NonExistentSubscription.new
    end
  rescue K2NonExistentSubscription => k2
    puts(k2.message)
  rescue StandardError => e
    puts(e.message)
  end
end