class K2Notification
  include K2Validation, K2Utilities
  attr_reader :location_url, :k2_response_body
  attr_accessor :access_token

  # Initialize with access_token
  def initialize(access_token)
    raise ArgumentError, 'Nil or Empty Access Token Given!' if access_token.blank?
    @threads = []
    @access_token = access_token
  end

  # Sends transaction notifications via SMS
  def send_sms_transaction_notification(params)
    k2_request_links = {
      callback_url: params[:callback_url]
    }
    k2_request_body = {
      webhook_event_reference: params[:webhook_event_reference],
      message: params[:message],
      _links: k2_request_links,
    }
    subscribe_hash = make_hash(K2Config.path_url('transaction_sms_notifications'), 'post', @access_token,'Notification', k2_request_body)
    @location_url =  K2Connect.make_request(subscribe_hash)
  end

  # Query Recent Webhook
  def query_resource(location_url = @location_url)
    query_hash = make_hash(location_url, 'get', @access_token, 'Notification', nil)
    @threads << Thread.new do
      sleep 0.25
      @k2_response_body = K2Connect.make_request(query_hash)
    end
    @threads.each(&:join)
  end

  # Query Specific Webhook URL
  def query_resource_url(url)
    query_resource(url)
  end
end
