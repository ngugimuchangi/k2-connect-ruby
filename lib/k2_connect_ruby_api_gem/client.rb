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
      test = JSON.parse(the_req.body.string).as_json
      puts ("Test Topic:\t#{test["topic"]}")
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
      puts("\n\nTopic:\t#{the_req_body["topic"]}\nReference:\t#{JSON.parse(the_req_body.deep_select("reference").to_s).join(', ')}\nMSISDN:\t#{the_req_body["msisdn"]}\nAmount:\t#{the_req_body["amount"]}\nCurrency:\t#{the_req_body["currency"]}\nTill Number:\t#{the_req_body["till_number"]}\nSystem:\t#{the_req_body["system"]}\nSender First Name:\t#{the_req_body["sender_first_name"]}\nSender Middle Name:\t#{the_req_body["sender_middle_name"]}\nSender Last Name:\t#{the_req_body["sender_last_name"]}\n")
    end
  end
end