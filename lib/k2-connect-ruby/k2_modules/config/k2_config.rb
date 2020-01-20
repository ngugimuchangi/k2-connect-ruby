# Module for Setting User-defined Environment Variables.
# TODO: try to see if you can implement Environment variables
module K2Config
  # Initialize module's instance variables
  @universal_callback_url = ''
  @base_url = 'http://127.0.0.1:3000'
  @path_endpoints = HashWithIndifferentAccess.new(oauth_token: 'oauth/token', webhook_subscriptions: 'webhook_subscriptions', pay_recipient: 'api/v1/pay_recipients', payments: 'api/v1/payments', incoming_payments: 'api/v1/incoming_payments')

  # Set the Host Url
  def self.set_base_url(base_url)
    raise ArgumentError, 'Invalid URL Format.' unless base_url =~ /\A#{URI.regexp(%w[http https])}\z/
    @base_url ||= base_url
  end

  def self.set_universal_callback_url(callback_url)
    raise ArgumentError, 'Invalid URL Format.' unless callback_url =~ /\A#{URI.regexp(%w[http https])}\z/
    @universal_callback_url = callback_url
  end

  def self.base_url
    @base_url
  end

  def self.callback_url
    @universal_callback_url
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
