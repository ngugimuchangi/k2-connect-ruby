module K2ConnectRubyApiGem
  class Client
    @secret_key
    def initialize(secret_key)
      @secret_key = secret_key
    end

    # Method for comparing the HMAC and with HTTP_X_KOPOKOPO_SIGNATURE
    def authorize_it(message_body, comparison_signature)
      digest = OpenSSL::Digest.new('sha256')
      hmac = OpenSSL::HMAC.hexdigest(digest, @secret_key, message_body)
      # puts("\n\nMessage Body: #{message_body}\n\nX-K2-Signature: #{JSON.parse(comparison_signature).join(', ')}\n\n The HMAC hash: #{hmac}")
      return hmac.to_s.eql?(JSON.parse(comparison_signature).join(', '))
    end

    def parse_it_whole(the_req)
      # The Response Body
      hash_body = Yajl::Parser.parse(the_req.body.string.to_json)
      # The Response Header
      hash_header = Yajl::Parser.parse(the_req.headers.env.select{|k, _| k =~ /^HTTP_/}.to_json)
      # The Response Method
      hash_method = Yajl::Parser.parse(the_req.method.to_json)
      hash_header.extend Hashie::Extensions::DeepFind
      if hash_method.eql?("POST")
        if authorize_it(hash_body.to_s, hash_header.deep_select("HTTP_X_KOPOKOPO_SIGNATURE").to_s)
          assign_req_elements(JSON.parse(the_req.body.string).as_json) and return
          return 200
        else
          return 401
        end
      else
        return 400
      end
    end

    def assign_req_elements(the_req_body)
      the_req_body.extend Hashie::Extensions::DeepFind
      puts("\nTopic:\t#{the_req_body["topic"]}\nReference:\t#{JSON.parse(the_req_body.deep_select("reference").to_s).join(', ')}\nMSISDN:\t#{JSON.parse(the_req_body.deep_select("sender_msisdn").to_s).join(', ')}\nAmount:\t#{JSON.parse(the_req_body.deep_select("amount").to_s).join(', ')}\nCurrency:\t#{JSON.parse(the_req_body.deep_select("currency").to_s).join(', ')}\nTill Number:\t#{JSON.parse(the_req_body.deep_select("till_number").to_s).join(', ')}\nSystem:\t#{JSON.parse(the_req_body.deep_select("system").to_s).join(', ')}\nSender First Name:\t#{JSON.parse(the_req_body.deep_select("sender_first_name").to_s).join(', ')}\nSender Middle Name:\t#{JSON.parse(the_req_body.deep_select("sender_middle_name").to_s).join(', ')}\nSender Last Name:\t#{JSON.parse(the_req_body.deep_select("sender_last_name").to_s).join(', ')}\n")
    end

    def lets_subscribe

    end

    def token_request(client_id, client_secret, client_credentials)
      # The return response
      k2_resp = k2_http.request(k2_req)
      # JSON data
      begin
        the_uri = URI("https://api-sandbox.kopokopo.com/oauth/v4/token")
        k2_http = Net::HTTP.new(the_uri.host, the_uri.port)
        k2_params = "{'Content-Type': 'application/x-www-form-urlencoded', 'Authorization'=> 'Basic'}"
        k2_req = Net::HTTP::Post.new(the_uri.path, k2_params.to_s)
        k2_req.body = {"client_id": "#{client_id}", "client_secret": "#{client_secret}", "grant_type": "#{client_credentials}"}.to_json
        resp = k2_http.request(k2_req)
        puts ("Response:\t#{resp.body}")
        puts JSON.parse(resp.body)
      rescue => e
        puts "failed #{e}"
      end
      # unsecure TZ site
      # http://www.remax.co.tz/publiclistinglist.aspx#mode=gallery&cr=2&cur=TZS&sb=PriceIncreasing&page=1&sc=115&sid=0441e3a5-17f0-43ba-9370-dfff27910df3
    end
  end
end