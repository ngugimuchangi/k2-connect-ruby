module K2ConnectRuby
  module K2Utilities
    module K2UrlParse
      extend self

      def remove_localhost(url)
        url.host = '127.0.0.1' if url.host.eql?('localhost')
        url
      end
    end
  end
end
