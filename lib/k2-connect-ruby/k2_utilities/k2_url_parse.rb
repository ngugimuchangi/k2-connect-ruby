# Module for dealing with Parsing URLS properly
module K2UrlParse
  def self.remove_localhost(url)
    url.host = '127.0.0.1' if url.host.eql?('localhost')
    url
  end
end