# Class for Subscription Service
class K2Subscribe
  include K2Validation, K2Utilities
  attr_reader :location_url, :k2_response_body
  attr_accessor :access_token, :webhook_secret

  # Initialize with the event_type
  def initialize(access_token)
    raise ArgumentError, 'Nil or Empty Access Token Given!' if access_token.blank?
    @threads = []
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
    @threads << Thread.new do
      sleep 0.25
      @k2_response_body = K2Connect.make_request(query_hash)
    end
    @threads.each(&:join)
  end

  # Query Specific Webhook URL
  def query_resource_url(url)
    query_webhook(url)
  end
end
