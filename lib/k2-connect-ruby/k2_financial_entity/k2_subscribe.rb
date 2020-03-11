# Class for Subscription Service
class K2Subscribe
  include K2Validation
  attr_reader :event_type, :location_url, :k2_response_body
  attr_accessor :access_token

  # Initialize with the event_type
  def initialize(access_token)
    raise ArgumentError, 'Nil or Empty Access Token Given!' if access_token.blank?
    @access_token = access_token
  end

  # Implemented a Case condition that minimises repetition
  def webhook_subscribe(webhook_secret = @webhook_secret, params)
    @webhook_secret = webhook_secret
    raise ArgumentError, 'Nil or Empty Webhook Specified!' if @webhook_secret.blank?
    params = validate_input(params, %w[event_type scope scope_reference url])
    validate_webhook(params[:event_type])
    k2_request_body = {
        event_type: params[:event_type],
        url: params[:url],
        secret: @webhook_secret,
        scope: params[:scope],
        scope_reference: params[:scope_reference]
    }
    subscribe_hash = K2Subscribe.make_hash(K2Config.path_url('webhook_subscriptions'), 'post', @access_token,'Subscription', k2_request_body)
    @location_url =  K2Connect.make_request(subscribe_hash)


  end

  # Query Recent Webhook
  def query_webhook
    query_hash = K2Pay.make_hash(@location_url, 'get', @access_token, 'Subscription', nil)
    @k2_response_body = K2Connect.make_request(query_hash)
  end

  # Query Specific Webhook URL
  def query_resource_url(url)
    query_hash = K2Pay.make_hash(url, 'get', @access_token, 'Subscription', nil)
    @k2_response_body = K2Connect.make_request(query_hash)
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
