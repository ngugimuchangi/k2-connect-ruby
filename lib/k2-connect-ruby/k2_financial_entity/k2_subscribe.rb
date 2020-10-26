# Class for Subscription Service
class K2Subscribe
  include K2Validation, K2Utilities
  attr_reader :location_url
  attr_accessor :access_token, :webhook_secret

  # Initialize with the event_type
  def initialize(access_token)
    raise ArgumentError, 'Nil or Empty Access Token Given!' if access_token.blank?
    @access_token = access_token
  end

  # Implemented a Case condition that minimises repetition
  def webhook_subscribe(params, webhook_secret = @webhook_secret)
    @webhook_secret = webhook_secret unless webhook_secret.blank?
    raise ArgumentError, 'Nil or Empty Webhook Specified!' if webhook_secret.blank?
    params = validate_input(params, %w[event_type scope scope_reference url])
    validate_webhook(params[:event_type])
    k2_request_body = {
        event_type: params[:event_type],
        url: params[:url],
        secret: @webhook_secret,
        scope: params[:scope],
        scope_reference: params[:scope_reference]
    }
    subscribe_hash = make_hash(K2Config.path_url('webhook_subscriptions'), 'post', @access_token,'Subscription', k2_request_body)
    @location_url =  K2Connect.make_request(subscribe_hash)


  end

  # Query Recent Webhook
  def query_webhook(location_url = @location_url)
    query_hash = make_hash(location_url, 'get', @access_token, 'Subscription', nil)
    K2Connect.make_request(query_hash)
  end

  # Query Specific Webhook URL
  def query_resource_url(url)
    query_webhook(url)
    # query_hash = make_hash(url, 'get', @access_token, 'Subscription', nil)
    # K2Connect.make_request(query_hash)
  end

  # Method for Validating the input itself
  # def validate_input(id, secret)
  #   raise ArgumentError, 'Empty Client Credentials' if id.blank? || secret.blank?
  # end

  def validate_webhook(event_type)
    case event_type
      # Buygoods Received
    when 'buygoods_transaction_received'
      return
      # Buygoods Reversed
    when 'buygoods_transaction_reversed'
      return
      # Customer Created.
    when 'customer_created'
      return
      # Settlement Transfer Completed
    when 'settlement_transfer_completed'
      return
      # External Till to Till Transfer Completed
    when 'b2b_transaction_received'
      return
      # Merchant to Merchant Transaction
    when 'm2m_transaction_received'
      return
    else
      raise ArgumentError, 'Subscription Service does not Exist!'
    end
  end
end
