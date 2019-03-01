# Class for Subscription Service
class K2Subscribe
  attr_writer :webhook_secret,
                :access_token,
                :event_type

  # Intialize with the event_type
  def initialize (event_type, webhook_secret)
    raise K2EmptyEvent.new if event_type.nil? || event_type == ""
    @event_type = event_type
    @webhook_secret = webhook_secret
  rescue K2EmptyEvent => k2
    return false
  rescue StandardError => e
    puts e.message
  end

  # Method for sending the request to K2 sandbox or Mock Server (Receives the access_token)
  def token_request(client_id, client_secret)
    # Validation
    validate_input(client_id, client_secret) and return

    token_params = {
        client_id: client_id,
        client_secret: client_secret,
        grant_type: "client_credentials"
    }
    # token_hash = {
    #     :path_url => "ouath",
    #     :is_get_request => false,
    #     :is_subscription => true,
    #     :params => token_params
    # }
    token_hash = K2Subscribe.put_in_hash("ouath", token_params)
    @access_token = K2Connect.to_connect(token_hash)
  end

  # Implemented a Case condition that minimises repetition
  def webhook_subscribe
    case
      # Buygoods Received
    when @event_type.match?("buygoods_transaction_received")
      k2_request_body = {
          event_type: "buygooods_transaction_received",
          url: "https://myapplication.com/webhooks",
          secret: @webhook_secret
      }
      # subscribe_hash = {
      #     :path_url => "webhook-subscription",
      #     :access_token =>  @access_token,
      #     :is_get_request => false,
      #     :is_subscription => true,
      #     :params => k2_request_body
      # }
      subscribe_hash = K2Subscribe.put_in_hash("webhook-subscription", k2_request_body)
      K2Connect.to_connect(subscribe_hash)

      # Buygoods Reversed
    when @event_type.match?("buygoods_transaction_reversed")
      k2_request_body = {
          event_type: "buygooods_transaction_reversed",
          url: "https://myapplication.com/webhooks",
          secret: "webhook_secret"
      }
      # subscribe_hash = {
      #     :path_url => "buygoods-transaction-reversed",
      #     :access_token =>  @access_token,
      #     :is_get_request => false,
      #     :is_subscription => true,
      #     :params => k2_request_body
      # }
      subscribe_hash = K2Subscribe.put_in_hash("buygoods_transaction_reversed", k2_request_body)
      K2Connect.to_connect(subscribe_hash)

      # Customer Created.
    when @event_type.match?("customer_created")
      k2_request_body = {
          event_type: "customer_created",
          url: "https://myapplication.com/webhooks",
          secret: @webhook_secret
      }
      # subscribe_hash = {
      #     :path_url => "customer-created",
      #     :access_token =>  @access_token,
      #     :is_get_request => false,
      #     :is_subscription => true,
      #     :params => k2_request_body
      # }
      subscribe_hash = K2Subscribe.put_in_hash("customer-created", k2_request_body)
      K2Connect.to_connect(subscribe_hash)

      # Settlement Transfer Completed
    when @event_type.match?("settlement_transfer_completed")
      k2_request_body = {
          event_type: "settlement",
          url: "https://myapplication.com/webhooks",
          secret: @webhook_secret
      }
      # subscribe_hash = {
      #     :path_url => "settlement",
      #     :access_token =>  @access_token,
      #     :is_get_request => false,
      #     :is_subscription => true,
      #     :params => k2_request_body
      # }
      subscribe_hash = K2Subscribe.put_in_hash("settlement", k2_request_body)
      K2Connect.to_connect(subscribe_hash)
    else
      raise K2NonExistentSubscription.new
    end
  rescue K2NonExistentSubscription => k2
    return false
  rescue StandardError => e
    puts(e.message)
  end

  # Method for Validating the input itself
  def validate_input(id, secret)
    if id.nil? || id == "" && secret.nil? || secret == ""
      "Empty Client Credentials"
    end
  end

  def self.put_in_hash(path_url, body)
    return {
        :path_url => path_url,
        :access_token =>  @access_token,
        :is_get_request => false,
        :is_subscription => true,
        :params => body
    }
  end
end