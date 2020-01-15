# Class for Subscription Service
class K2Subscribe
  attr_reader :event_type
  attr_accessor :access_token

  # Intialize with the event_type
  def initialize(webhook_secret, access_token)
    raise ArgumentError, 'Nil or Empty Webhook Specified!' if webhook_secret.blank?
    raise ArgumentError, 'Nil or Empty Access Token Given!' if access_token.blank?
    @webhook_secret = webhook_secret
    @access_token = access_token
  end

  # Implemented a Case condition that minimises repetition
  def webhook_subscribe(event_type)
    raise ArgumentError, 'Nil or Empty Event Type Specified!' if event_type.blank?
    case event_type
      # Buygoods Received
    when 'buygoods_transaction_received'
      k2_request_body = {
        event_type: 'buygoods_transaction_received',
        url: 'https://myapplication.com/webhooks',
        secret: @webhook_secret
      }
      the_path_url = 'api/v1/webhook_subscriptions'

      # Buygoods Reversed
    when 'buygoods_transaction_reversed'
      k2_request_body = {
        event_type: 'buygoods_transaction_reversed',
        url: 'https://myapplication.com/webhooks',
        secret: @webhook_secret
      }
      the_path_url = 'api/v1/buygoods-transaction-reversed'

      # Customer Created.
    when 'customer_created'
      k2_request_body = {
        event_type: 'customer_created',
        url: 'https://myapplication.com/webhooks',
        secret: @webhook_secret
      }
      the_path_url = 'api/v1/customer-created'

      # Settlement Transfer Completed
    when 'settlement_transfer_completed'
      k2_request_body = {
        event_type: 'settlement',
        url: 'https://myapplication.com/webhooks',
        secret: @webhook_secret
      }
      the_path_url = 'api/v1/settlement'

      # Settlement Transfer Completed
    when 'external_till_to_till'
      k2_request_body = {
        event_type: 'b2b_transaction_received',
        url: 'https://myapplication.com/webhooks',
        secret: @webhook_secret
      }
      the_path_url = 'api/v1/b2b-transaction-received'

      # Settlement Transfer Completed
    when 'k2_merchant_to_merchant'
      k2_request_body = {
        event_type: 'merchant_to_merchant',
        url: 'https://myapplication.com/webhooks',
        secret: @webhook_secret
      }
      the_path_url = 'api/v1/merchant-to-merchant'
    else
      raise ArgumentError, 'Subscription Service does not Exist!'
    end
    subscribe_hash = K2Subscribe.make_hash(the_path_url, 'POST', @access_token,'Subscription', k2_request_body)
    K2Connect.connect(subscribe_hash)
  end

  # Method for Validating the input itself
  def validate_input(id, secret)
    raise ArgumentError, 'Empty Client Credentials' if id.blank? || secret.blank?
  end

  # Create a Hash containing important details accessible for K2Connect
  def self.make_hash(path_url, request, access_token, class_type, body)
    {
      path_url: path_url,
      access_token: access_token,
      request_type: request,
      class_type: class_type,
      params: body
    }.with_indifferent_access
  end
end
