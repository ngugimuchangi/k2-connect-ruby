# Module for Setting User-defined Environment Variables.
module K2Config
  attr_accessor :host_url
  # Set the Host Url
  def self.set_host_url(host_url)
    raise ArgumentError, 'Invalid URL Format.' unless host_url =~ /\A#{URI.regexp(%w[http https])}\z/

    @host_url = host_url
  end

  # Get the Host Url
  def self.get_host_url
    @host_url
  end
end
