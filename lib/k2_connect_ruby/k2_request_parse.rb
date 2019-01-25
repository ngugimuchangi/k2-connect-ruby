module K2ConnectRuby
  class K2RequestParse
    @hash_body
    @hash_header
    @hash_method
    # Method for parsing the Entire Request. Come back to it later to trim.
    def parse_request(the_request)
      # The Response Body
      @hash_body = Yajl::Parser.parse(the_request.body.string.to_json)
      # The Response Header
      @hash_header = Yajl::Parser.parse(the_request.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json).deep_select("HTTP_X_KOPOKOPO_SIGNATURE").to_s
      # The Response Method
      @hash_method = Yajl::Parser.parse(the_request.method.to_json)
    end
  end
end