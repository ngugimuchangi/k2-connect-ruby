# Class for Subscription Service
class K2Subscribe
  include K2Validation, K2Utilities
  attr_reader :location_url
  attr_accessor :access_token, :webhook_secret

  ALL_EVENT_TYPES = %[buygoods_transaction_received b2b_transaction_received buygoods_transaction_reversed customer_created settlement_transfer_completed m2m_transaction_received]
  TILL_SCOPE_EVENT_TYPES = %[buygoods_transaction_received b2b_transaction_received buygoods_transaction_reversed]

  # Initialize with the event_type
  def initialize(access_token)
    raise ArgumentError, 'Nil or Empty Access Token Given!' if access_token.blank?
    @access_token = access_token
  end

  # Implemented a Case condition that minimises repetition
  def webhook_subscribe(params)
    params = validate_webhook_input(params)
    validate_webhook(params)
    k2_request_body = {
        event_type: params[:event_type],
        url: params[:url],
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
  end

  private

  def validate_webhook(params)
    raise ArgumentError, 'Subscription Service does not Exist!' unless params[:event_type].in?(ALL_EVENT_TYPES)

    determine_scope_details(params)
  end

  def validate_webhook_input(params)
    if params[:event_type].in?(TILL_SCOPE_EVENT_TYPES)
      validate_input(params, %w[event_type scope scope_reference url])
    else
      validate_input(params.except(:scope_reference), %w[event_type scope url])
    end
  end

  def determine_scope_details(params)
    if params[:scope].eql?('till')
      raise ArgumentError, "Invalid scope till for the event type" unless params[:event_type].in?(TILL_SCOPE_EVENT_TYPES)
    end
  end

  end
