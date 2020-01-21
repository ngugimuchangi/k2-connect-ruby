# Module for Setting User-defined Environment Variables.
# TODO: try to see if you can implement Environment variables
module K2Config
  # Initialize module's instance variables
  @version_no = 'v1'
  @universal_callback_url = ''
  @base_url = "http://127.0.0.1:3000"
  @path_endpoints = HashWithIndifferentAccess.new(oauth_token: 'oauth/token', webhook_subscriptions: "api/#{@version_no}/webhook_subscriptions", pay_recipient: "api/#{@version_no}/pay_recipients",
                                                  payments: "api/#{@version_no}/payments", incoming_payments: "api/#{@version_no}/incoming_payments")
  @callback_urls = HashWithIndifferentAccess.new(webhook_subscriptions: 'http://127.0.0.1:3003/webhook_subscription', payments: 'http://127.0.0.1:3003/payment_result',
                                                 incoming_payments: 'http://127.0.0.1:3003/stk_payment')

  # Set the Host Url
  def self.set_base_url(base_url)
    raise ArgumentError, 'Invalid URL Format.' unless base_url =~ /\A#{URI.regexp(%w[http https])}\z/
    @base_url ||= base_url
  end

  def self.set_universal_callback_url(callback_url)
    raise ArgumentError, 'Invalid URL Format.' unless callback_url =~ /\A#{URI.regexp(%w[http https])}\z/
    @universal_callback_url = callback_url
  end

  def self.set_webhook_callback(callback_url)
    @callback_urls[:webhook_subscriptions] = callback_url
  end

  def self.set_payments_callback(callback_url)
    @callback_urls[:payments] = callback_url
  end

  def self.set_incoming_payments_callback(callback_url)
    @callback_urls[:incoming_payments] = callback_url
  end

  # TODO: Versioning
  def self.set_version_no(version_no)
    raise ArgumentError, 'Invalid Format: Version Number input should be Numeric' unless version_no.is_a?(Numeric)
    @version_no = "v#{version_no}"
  end

  def self.base_url
    @base_url
  end

  def self.version_no
    @version_no = "v#{@version_no}"
  end

  def self.universal_callback_url
    @universal_callback_url
  end

  def self.callback_url(context)
    @callback_urls[:"#{context}"]
  end

  def self.path_variable(key)
    @path_endpoints[:"#{key}"]
  end

  def self.path_variables
    @path_endpoints
  end

  def self.complete_url(key)
    @base_url + '/' + path_variable(key)
  end

end
