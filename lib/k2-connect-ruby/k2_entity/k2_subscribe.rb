# Class for Subscription Service
class K2Subscribe
  attr_accessor :access_token
  attr_writer :webhook_secret, :event_type

  # Intialize with the event_type
  def initialize (event_type, webhook_secret)
    raise ArgumentError.new("Nil or Empty Event Type Specified!") if event_type.blank?
    @event_type = event_type
    @webhook_secret = webhook_secret
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
    token_hash = K2Subscribe.make_hash("ouath", "POST", "Subscription", token_params)
    @access_token = K2Connect.to_connect(token_hash)
  end

  # Implemented a Case condition that minimises repetition
  def webhook_subscribe
    case
      # Buygoods Received
    when @event_type.match?("buygoods_transaction_received")
      k2_request_body = {
          event_type: "buygoods_transaction_received",
          url: "https://myapplication.com/webhooks",
          secret: @webhook_secret
      }
      subscribe_hash = K2Subscribe.make_hash("webhook-subscription", "POST", "Subscription", k2_request_body)
      K2Connect.to_connect(subscribe_hash)

      # Buygoods Reversed
    when @event_type.match?("buygoods_transaction_reversed")
      k2_request_body = {
          event_type: "buygooods_transaction_reversed",
          url: "https://myapplication.com/webhooks",
          secret: "webhook_secret"
      }
      subscribe_hash = K2Subscribe.make_hash("buygoods_transaction_reversed", "POST", "Subscription", k2_request_body)
      K2Connect.to_connect(subscribe_hash)

      # Customer Created.
    when @event_type.match?("customer_created")
      k2_request_body = {
          event_type: "customer_created",
          url: "https://myapplication.com/webhooks",
          secret: @webhook_secret
      }
      subscribe_hash = K2Subscribe.make_hash("customer-created", "POST", "Subscription", k2_request_body)
      K2Connect.to_connect(subscribe_hash)

      # Settlement Transfer Completed
    when @event_type.match?("settlement_transfer_completed")
      k2_request_body = {
          event_type: "settlement",
          url: "https://myapplication.com/webhooks",
          secret: @webhook_secret
      }
      subscribe_hash = K2Subscribe.make_hash("settlement", "POST", "Subscription", k2_request_body)
      K2Connect.to_connect(subscribe_hash)
    else
      raise ArgumentError.new("Subscription Service does not Exist!")
    end
  end

  # Method for Validating the input itself
  def validate_input(id, secret)
    if id.blank? || secret.blank?
      raise ArgumentError.new("Empty Client Credentials")
    end
  end

  # Create a Hash containing important details accessible for K2Connect
  def self.make_hash(path_url, request, class_type, body)
    return {
        path_url: path_url,
        request_type: request,
        class_type: class_type,
        params: body
    }
  end
end