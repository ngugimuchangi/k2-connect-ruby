# Class for Subscription Service
class K2Subscribe
  attr_accessor :access_token
  attr_reader :event_type

  # Intialize with the event_type
  def initialize(event_type, webhook_secret)
    raise ArgumentError, 'Nil or Empty Event Type Specified!' if event_type.blank?

    @event_type = event_type
    @webhook_secret = webhook_secret
  end

  # Method for sending the request to K2 sandbox or Mock Server (Receives the access_token)
  def token_request(client_id, client_secret)
    # Validation
    validate_input(client_id, client_secret) && return

    token_params = {
      client_id: client_id,
      client_secret: client_secret,
      grant_type: 'client_credentials'
    }
    token_hash = K2Subscribe.make_hash('ouath', 'POST', 'Subscription', token_params)
    @access_token = K2Connect.to_connect(token_hash)
  end

  # Implemented a Case condition that minimises repetition
  def webhook_subscribe
    case @event_type
      # Buygoods Received
    when 'buygoods_transaction_received'
      k2_request_body = {
        event_type: 'buygoods_transaction_received',
        url: 'https://myapplication.com/webhooks',
        secret: @webhook_secret
      }
      the_path_url = 'webhook-subscription'

      # Buygoods Reversed
    when 'buygoods_transaction_reversed'
      k2_request_body = {
        event_type: 'buygooods_transaction_reversed',
        url: 'https://myapplication.com/webhooks',
        secret: @webhook_secret
      }
      the_path_url = 'buygoods-transaction-reversed'

      # Customer Created.
    when 'customer_created'
      k2_request_body = {
        event_type: 'customer_created',
        url: 'https://myapplication.com/webhooks',
        secret: @webhook_secret
      }
      the_path_url = 'customer-created'

      # Settlement Transfer Completed
    when 'settlement_transfer_completed'
      k2_request_body = {
        event_type: 'settlement',
        url: 'https://myapplication.com/webhooks',
        secret: @webhook_secret
      }
      the_path_url = 'settlement'

      # Settlement Transfer Completed
    when 'external_till_to_till'
      k2_request_body = {
        event_type: 'b2b_transaction_received',
        url: 'https://myapplication.com/webhooks',
        secret: @webhook_secret
      }
      the_path_url = 'b2b-transaction-received'

      # Settlement Transfer Completed
    when 'k2_merchant_to_merchant'
      k2_request_body = {
        event_type: 'merchant_to_merchant',
        url: 'https://myapplication.com/webhooks',
        secret: @webhook_secret
      }
      the_path_url = 'merchant-to-merchant'
    else
      raise ArgumentError, 'Subscription Service does not Exist!'
    end
    subscribe_hash = K2Subscribe.make_hash(the_path_url, 'POST', 'Subscription', k2_request_body)
    K2Connect.to_connect(subscribe_hash)
  end

  # Method for Validating the input itself
  def validate_input(id, secret)
    raise ArgumentError, 'Empty Client Credentials' if id.blank? || secret.blank?
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
